class MissionAssignment < ApplicationRecord
  belongs_to :mission
  belongs_to :user

  validates :user_id, uniqueness: { scope: :mission_id }
end
