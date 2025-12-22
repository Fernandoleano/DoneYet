class CreateWorkspaceAnnouncements < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_announcements do |t|
      t.references :workspace, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :content
      t.integer :priority
      t.boolean :pinned

      t.timestamps
    end
  end
end
