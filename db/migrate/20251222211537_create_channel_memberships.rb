class CreateChannelMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :channel_memberships do |t|
      t.references :channel, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
