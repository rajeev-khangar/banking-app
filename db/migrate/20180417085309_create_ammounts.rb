class CreateAmmounts < ActiveRecord::Migration
  def change
    create_table :ammounts do |t|
      t.float :total_ammount, default: 0.0
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
