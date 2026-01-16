class CreateAccountJoinCodes < ActiveRecord::Migration[8.2]
  def change
    create_table :account_join_codes, id: :uuid do |t|
      t.references :account, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :code, null: false
      t.integer :usage_limit, default: 100, null: false
      t.integer :usage_count, default: 0, null: false

      t.timestamps
    end
    add_index :account_join_codes, :code, unique: true
  end
end
