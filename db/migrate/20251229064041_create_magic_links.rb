class CreateMagicLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :magic_links, id: :uuid do |t|
      t.string :code
      t.references :identity, null: false, foreign_key: true, type: :uuid
      t.datetime :expires_at
      t.integer :purpose

      t.timestamps
    end
    add_index :magic_links, :code
    add_index :magic_links, :expires_at
  end
end
