class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  belongs_to :workspace

  has_one :user_stat, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements

  # Ahoy Analytics
  has_many :ahoy_visits, class_name: "Ahoy::Visit"
  has_many :ahoy_events, class_name: "Ahoy::Event"

  has_one_attached :avatar

  has_many :feature_votes, dependent: :destroy
  has_many :voted_features, through: :feature_votes, source: :feature_request

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :password_reset, expires_in: 20.minutes do
    password_salt&.last(10)
  end

  enum :role, { agent: "agent", captain: "captain" }, default: "agent"
  enum :user_type, { solo: "solo", team: "team" }, default: "team"

  validates :name, presence: true

  after_create :create_user_stat
  after_create_commit :send_welcome_email

  # Access Control for Feature Gating
  def has_full_access?
    # Admin, beta users, or Pro workspace
    email_address == "fernandoleano4@gmail.com" ||
    beta_user? ||
    workspace&.pro?
  end

  def can_access_feature?(feature)
    return true if has_full_access?

    case feature
    when :analytics then false
    when :automations then false
    when :calendar then false
    when :chat then false
    when :advanced_channels then false
    when :feature_voting then false
    when :file_attachments then false
    else true
    end
  end

  private

  def create_user_stat
    build_user_stat.save
  end

  def send_welcome_email
    UserMailer.welcome(self).deliver_later
  end
end
