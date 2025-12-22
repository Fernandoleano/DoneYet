class CreateMissionAssignments < ActiveRecord::Migration[8.1]
  def change
    create_table :mission_assignments do |t|
      t.references :mission, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :mission_assignments, [ :mission_id, :user_id ], unique: true
  end
end
