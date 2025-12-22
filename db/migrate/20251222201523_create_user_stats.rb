class CreateUserStats < ActiveRecord::Migration[8.1]
  def change
    create_table :user_stats do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.integer :total_xp, default: 0
      t.integer :level, default: 1
      t.integer :missions_completed, default: 0
      t.integer :missions_created, default: 0
      t.integer :comments_posted, default: 0
      t.integer :current_streak, default: 0
      t.integer :longest_streak, default: 0
      t.date :last_login_date
      t.string :rank, default: "Recruit"
      t.string :code_name

      t.timestamps
    end
  end
end
