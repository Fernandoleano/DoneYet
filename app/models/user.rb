class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :workspace

  has_one :user_stat, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { agent: "agent", captain: "captain" }, default: "agent"

  validates :name, presence: true

  after_create :create_user_stat

  private

  def create_user_stat
    build_user_stat.save
  end
end
