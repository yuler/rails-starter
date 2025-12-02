class CreateAccountInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :account_invitations do |t|
      t.references :account, null: false, foreign_key: true
      t.string :email, null: false
      t.string :token, null: false
      t.string :role
      t.references :invited_by, null: true, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :account_invitations, :token, unique: true
    add_index :account_invitations, [:account_id, :email], unique: true
  end
end
