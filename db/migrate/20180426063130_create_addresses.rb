class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.integer :user_id
      t.string :line1_address
      t.string :line2_address
      t.string :landmark
      t.string :district
      t.string :city
      t.string :state
      t.string :country
      t.integer :pincode
      t.string :address_type
      t.timestamps null: false
    end
  end
end
