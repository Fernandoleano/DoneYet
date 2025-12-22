class CreateMissions < ActiveRecord::Migration[8.1]
  def change
    create_table :missions do |t|
      t.references :meeting, null: false, foreign_key: true
      t.references :agent, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.integer :status
      t.datetime :due_at
      t.datetime :last_reminded_at
      t.integer :dispatch_status
      t.jsonb :dispatch_metadata

      t.timestamps
    end
  end
end
