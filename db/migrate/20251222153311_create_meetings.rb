class CreateMeetings < ActiveRecord::Migration[8.1]
  def change
    create_table :meetings do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :captain, null: false, foreign_key: { to_table: :users }
      t.string :title
      t.integer :status
      t.datetime :started_at
      t.datetime :dispatched_at

      t.timestamps
    end
  end
end
