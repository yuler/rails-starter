class CreateInviteCodes < ActiveRecord::Migration[8.1]
  def change
    create_table :invite_codes do |t|
      t.string :code, null: false

      t.timestamps
    end
    add_index :invite_codes, :code, unique: true
  end
end
