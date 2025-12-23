class AddTimeTrackingToMissions < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :time_tracked_seconds, :integer, default: 0
    add_column :missions, :timer_started_at, :datetime
    add_column :missions, :is_timer_running, :boolean, default: false
  end
end
