class AddProviderToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :provider, :integer
  end
end
