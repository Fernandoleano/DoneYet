class AddMeetCodeToMeetings < ActiveRecord::Migration[8.1]
  def change
    add_column :meetings, :meet_code, :string
    add_index :meetings, :meet_code
  end
end
