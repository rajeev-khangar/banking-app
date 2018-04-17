class User < ActiveRecord::Base
  has_one :ammount
  has_many :statements
  validates :email, presence: true
  validates :account_number, presence: true, uniqueness: true
  after_create :create_ammount

  def create_ammount
    Ammount.create(user_id: self.id)
  end

  def deposit(money)
    status = if ammount.update(total_ammount: ammount.total_ammount.to_f + money.to_f)  
      "success"
    else
      "Failed"
    end
    @statement = Statement.create(date: Time.now, deposit: money.to_f, total_balance: ammount.total_ammount, status: status)
    TransactionMailer.send_info(self, @statement)
  end

  def withdraw(money)
    return errors.add(:total_ammount, "is not sufficient") if ammount.total_ammount.to_f < money.to_f
    status = if ammount.update(total_ammount: ammount.total_ammount.to_f - money.to_f)  
      "success"
    else
      "Failed"
    end
    @statement = Statement.create(date: Time.now, withdraw: money.to_f, total_balance: ammount.total_ammount, status: status)
    TransactionMailer.send_info(self, @statement)
  end

  def enquiry
    ammount.total_ammount
  end
end


