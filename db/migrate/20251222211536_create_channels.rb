class CreateChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :channels do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.boolean :private, default: false
      t.integer :created_by_id

      t.timestamps
    end

    add_index :channels, [ :workspace_id, :name ], unique: true
  end
end
