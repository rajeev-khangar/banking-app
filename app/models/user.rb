require 'csv'
class User < ActiveRecord::Base
  has_one :amount
  has_many :statements
  has_many :addresses, inverse_of: :user
  validates :first_name, :last_name, presence: true
  validates :account_number, presence: true, uniqueness: true
  validates :email,  presence: true, uniqueness: true
  validates :phone_number,  presence: true , uniqueness: true, :length => { :minimum => 10, :maximum => 12 }
  validates :pancard_number, uniqueness: true, :length => { :minimum => 5, :maximum => 6 }
  validates :aadhaar_number, uniqueness: true, presence: true, :length => { :minimum => 15, :maximum => 16 }, :numericality => true
  before_validation :generate_account_number
  after_create :create_amount
  accepts_nested_attributes_for :addresses, allow_destroy: true

  def create_amount
    Amount.create(user_id: self.id)
  end

  def deposit(money)
    ActiveRecord::Base.transaction do  
      if amount.update(total_amount: amount.total_amount.to_f + money.to_f)  
        @statement = statements.create(date: Time.now, deposit: money.to_f, total_balance: amount.total_amount, status: "success")
        value = true
      else
        @statement = statements.create(date: Time.now, deposit: money.to_f, total_balance: amount.total_amount, status: "Failed")
        value = false
      end
      TransactionMailer.send_info(self, @statement).deliver_now
      return value
    end
  end

  def withdraw(money)
    ActiveRecord::Base.transaction do  
      if amount.total_amount.to_f < money.to_f
        errors.add(:total_amount, "is not sufficient") 
        return false
      end 
      if amount.update(total_amount: amount.total_amount.to_f - money.to_f)  
        @statement = statements.create(date: Time.now, withdraw: money.to_f, total_balance: amount.total_amount, status: "success")
        value = true
      else
        @statement = statements.create(date: Time.now, withdraw: money.to_f, total_balance: amount.total_amount, status: "Failed")
        value = false
      end
      TransactionMailer.send_info(self, @statement).deliver_now
      return value
    end
  end

  def enquiry
    amount.total_amount
  end

  def import(statements)
    CSV.generate(headers: true) do |csv|
      csv << ["User Name", "Account Number", "Date", "Withdraw Amount", "Deposit Amount", "Balance", "Status"]
      user_ids = []
      statements.each do |statement|
        arr = []
        arr << (user_ids.include?(self.id) ? "" : UserDecorator.new(self).full_name)
        arr << (user_ids.include?(self.id) ? "" : self.account_number)
        arr << (user_ids.include?(self.id) ? "" : self.email)
        arr << statement.date.strftime("%Y-%m-%d %H:%M")
        arr << statement.withdraw
        arr << statement.deposit
        arr << statement.total_balance
        arr << statement.status
        user_ids << self.id
        csv << arr
      end
      csv << []
      csv << ["", "", "", "", "Total Balance", self.statements.last.try(:total_balance)]
    end
  end

  def self.import(users)
    CSV.generate(headers: true) do |csv|
      csv << ["User Name", "Account Number", "Date", "Withdraw Amount", "Deposit Amount", "Balance", "Status"]
      user_ids = []
      User.all.each do |user|
        user.statements.each do |statement|
          arr = []
          arr << (user_ids.include?(user.id) ? "" : UserDecorator.new(user).full_name)
          arr << (user_ids.include?(user.id) ? "" : user.account_number)
          arr << (user_ids.include?(self.id) ? "" : self.email)
          arr << statement.date.strftime("%Y-%m-%d %H:%M")
          arr << statement.withdraw
          arr << statement.deposit
          arr << statement.total_balance
          arr << statement.status
          user_ids << user.id
          csv << arr
        end
        if user.statements.present?
          csv << []
          csv << ["", "", "", "", "Total Balance", user.statements.last.try(:total_balance)]
          csv << []
        end
      end
    end
  end
  
  def generate_account_number
    if self.account_number.blank?
      user_account_number = "123456"+ rand(0000000000..9999999999).to_s
      while User.find_by(account_number: user_account_number).present?
        user_account_number = "123456"+ rand(0000000000..9999999999).to_s
      end
      self.account_number = user_account_number
    end
  end
end


