class CreateAutomations < ActiveRecord::Migration[8.1]
  def change
    create_table :automations do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :name
      t.integer :automation_type
      t.json :config
      t.boolean :enabled, default: true
      t.datetime :last_run_at
      t.datetime :next_run_at

      t.timestamps
    end
  end
end
