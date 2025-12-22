class AddInProgressStatusToMissions < ActiveRecord::Migration[8.1]
  def up
    # Add new columns for tracking status transitions
    add_column :missions, :started_at, :datetime
    add_column :missions, :completed_at, :datetime

    # Update existing missions to set completed_at for done missions
    execute <<-SQL
      UPDATE missions#{' '}
      SET completed_at = updated_at#{' '}
      WHERE status = 1
    SQL
  end

  def down
    remove_column :missions, :started_at
    remove_column :missions, :completed_at
  end
end
