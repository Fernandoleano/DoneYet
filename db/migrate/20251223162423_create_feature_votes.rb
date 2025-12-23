class CreateFeatureVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :feature_votes do |t|
      t.references :feature_request, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :feature_votes, [ :feature_request_id, :user_id ], unique: true
  end
end
