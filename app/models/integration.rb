class Integration < ApplicationRecord
  belongs_to :workspace

  enum :provider, { slack: 0, zoho_cliq: 1 }

  encrypts :access_token
  encrypts :refresh_token

  validates :provider, presence: true
  validates :workspace_id, uniqueness: { scope: :provider, message: "already has an integration for this provider" }
end
