class AddConfirmedAtToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :confirmed_at, :datetime
  end
end
