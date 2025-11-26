class CreateMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :memberships do |t|
      t.references :account, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :role, null: false, default: 'member'

      t.timestamps

      t.index [ :account_id, :user_id ], unique: true
      t.index [ :role ]
    end
  end
end
