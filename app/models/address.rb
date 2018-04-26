class Address < ActiveRecord::Base
  belongs_to :user, inverse_of: :addresses
  validates :line1_address, presence: true
  validates :line2_address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :country, presence: true
  validates :district, presence: true
  validates :landmark, presence: true
  validates :address_type, presence: true, inclusion: ["Local Address", "Permanent Address"]
  validates :pincode, presence: true, :length => { :minimum => 5, :maximum => 6 }, :numericality => true
end
