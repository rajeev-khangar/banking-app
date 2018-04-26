require 'rails_helper'

RSpec.describe Amount, type: :model do
  it { should belong_to(:user)}
end