class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :description
      t.integer :kind, null: false, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :accounts, :name, unique: true
  end
end
