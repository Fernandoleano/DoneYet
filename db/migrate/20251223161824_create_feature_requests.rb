class CreateFeatureRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_requests do |t|
      t.string :title
      t.text :description
      t.integer :votes_count, default: 0

      t.timestamps
    end
  end
end
