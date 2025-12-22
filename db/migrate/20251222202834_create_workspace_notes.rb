class CreateWorkspaceNotes < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_notes do |t|
      t.references :workspace, null: false, foreign_key: true
      t.text :content
      t.string :note_type

      t.timestamps
    end
  end
end
