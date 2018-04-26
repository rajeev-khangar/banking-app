class AddColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :aadhaar_number, :string
    add_column :users, :pancard_number, :string
  end
end
