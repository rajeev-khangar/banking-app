class CreateStatements < ActiveRecord::Migration
  def change
    create_table :statements do |t|
      t.references :user, index: true, foreign_key: true
      t.float :withdraw
      t.float :deposit
      t.float :total_balance
      t.string :status
      t.datetime :date
      t.timestamps null: false
    end
  end
end
