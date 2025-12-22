class AddGamificationToMissions < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :difficulty, :integer, default: 1 # medium
    add_column :missions, :xp_reward, :integer, default: 100
    add_column :missions, :threat_level, :integer, default: 1 # medium
  end
end
