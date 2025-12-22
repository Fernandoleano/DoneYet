class CreateMissionComments < ActiveRecord::Migration[8.1]
  def change
    create_table :mission_comments do |t|
      t.references :mission, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
