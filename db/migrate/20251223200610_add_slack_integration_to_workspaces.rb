class AddSlackIntegrationToWorkspaces < ActiveRecord::Migration[8.1]
  def change
    add_column :workspaces, :slack_team_id, :string
    add_column :workspaces, :slack_team_name, :string
    add_column :workspaces, :slack_access_token, :string
    add_column :workspaces, :slack_bot_token, :string
    add_column :workspaces, :slack_webhook_url, :string
    add_column :workspaces, :slack_connected_at, :datetime

    add_index :workspaces, :slack_team_id
  end
end
