class CreateAmounts < ActiveRecord::Migration
  def change
    create_table :amounts do |t|
      t.float :total_amount, default: 0.0
      t.references :user, index: true, foreign_key: true
      t.timestamps null: false
    end
  end
end
