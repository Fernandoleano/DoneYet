class AddStripeToWorkspaces < ActiveRecord::Migration[8.1]
  def change
    add_column :workspaces, :stripe_customer_id, :string
    add_index :workspaces, :stripe_customer_id
    add_column :workspaces, :stripe_subscription_id, :string
    add_index :workspaces, :stripe_subscription_id
    add_column :workspaces, :subscription_status, :integer
  end
end
