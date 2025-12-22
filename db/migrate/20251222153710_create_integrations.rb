class CreateIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :integrations do |t|
      t.references :workspace, null: false, foreign_key: true
      t.integer :provider
      t.text :access_token
      t.text :refresh_token
      t.string :bot_user_id
      t.jsonb :configuration

      t.timestamps
    end
  end
end
