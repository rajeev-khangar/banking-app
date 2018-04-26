FactoryGirl.define do
  factory :user do
    email "user@example.com"
    account_number "110001122"
    first_name "test" 
    last_name "user"
    aadhaar_number "1234567891234567"
    phone_number "01234567891"
    pancard_number "123456"
  end
end