class CreateAchievements < ActiveRecord::Migration[8.1]
  def change
    create_table :achievements do |t|
      t.string :key, null: false
      t.string :name, null: false
      t.text :description
      t.string :icon
      t.integer :xp_reward, default: 0
      t.string :category
      t.string :tier
      t.json :requirements

      t.timestamps
    end

    add_index :achievements, :key, unique: true
  end
end
