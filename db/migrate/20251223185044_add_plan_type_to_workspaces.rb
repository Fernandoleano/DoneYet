class AddPlanTypeToWorkspaces < ActiveRecord::Migration[8.1]
  def change
    add_column :workspaces, :plan_type, :string
  end
end
