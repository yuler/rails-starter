class AddPersonalAccountSupport < ActiveRecord::Migration[8.2]
  def change
    # Mark whether an account is a personal (solo) account
    add_column :accounts, :personal, :boolean, default: false, null: false
    add_index :accounts, :personal
  end
end
