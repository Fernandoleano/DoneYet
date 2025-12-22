class AddDescriptionToMissions < ActiveRecord::Migration[8.1]
  def change
    add_column :missions, :description, :text
  end
end
