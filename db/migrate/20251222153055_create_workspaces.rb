class CreateWorkspaces < ActiveRecord::Migration[8.1]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.jsonb :settings

      t.timestamps
    end
  end
end
