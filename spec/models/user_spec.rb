require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_one(:amount)}
  it { should have_many(:statements)}
  it { should have_many(:addresses)}  
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:phone_number) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_uniqueness_of(:account_number) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_uniqueness_of(:phone_number) }

  describe '#create_amount' do
    it 'does create amount' do
      expect(Amount.count).to eq 0
      User.any_instance.stub(email: "abhi@mail.com", account_number: "1234567890", first_name: "test", last_name: "user", phone_number: "12345678912", aadhaar_number: "1234567891234567", pancard_number: "123456")
      user = User.create
      expect(Amount.count).to eq 1
      expect(user.amount).to eq Amount.last
    end
  end

  describe '#deposit' do
    it 'does increase total balance of user' do
    	User.any_instance.stub(email: "abhi@mail.com", account_number: "1234567890", first_name: "test", last_name: "user", phone_number: "12345678912", aadhaar_number: "1234567891234567", pancard_number: "123456")
      user = User.create
      expect(user.amount.total_amount).to eq 0.0
      user.deposit(5000)
      expect(user.amount.total_amount).to eq 5000.0
      expect(Statement.last.deposit).to eq 5000.0
    end
  end

  describe '#withdraw' do
    context 'if not sufficient balance' do
      it 'does return error' do
        User.any_instance.stub(email: "abhi@mail.com", account_number: "1234567890", first_name: "test", last_name: "user", phone_number: "12345678912", aadhaar_number: "1234567891234567", pancard_number: "123456")
        user = User.create
        expect(user.amount.total_amount).to eq 0.0
        user.withdraw(5000)
        expect(user.errors[:total_amount]).to eq ["is not sufficient"]
      end
    end

    context 'if sufficient balance' do
      it 'does decrease total_amount of user' do
        User.any_instance.stub(email: "abhi@mail.com", account_number: "1234567890", first_name: "test", last_name: "user", phone_number: "12345678912", aadhaar_number: "1234567891234567", pancard_number: "123456")
        user = User.create
        Amount.last.update(total_amount: 10000.0)
        expect(user.amount.total_amount).to eq 10000.0
        user.withdraw(6000)
        expect(user.amount.total_amount).to eq 4000.0
        expect(Statement.last.withdraw).to eq 6000.0
      end
    end
  end
end

