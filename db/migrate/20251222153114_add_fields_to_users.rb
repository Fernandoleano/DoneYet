class AddFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_reference :users, :workspace, null: false, foreign_key: true
    add_column :users, :name, :string
    add_column :users, :role, :string
    add_column :users, :slack_user_id, :string
    add_column :users, :zoho_user_id, :string
  end
end
