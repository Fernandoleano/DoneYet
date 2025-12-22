class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :workspace

  has_one_attached :avatar

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :role, { agent: "agent", captain: "captain" }, default: "agent"

  validates :name, presence: true
end
