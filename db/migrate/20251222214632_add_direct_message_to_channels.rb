class AddDirectMessageToChannels < ActiveRecord::Migration[8.1]
  def change
    add_column :channels, :is_direct_message, :boolean, default: false, null: false
  end
end
