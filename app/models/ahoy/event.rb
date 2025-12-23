class Ahoy::Event < ApplicationRecord
  self.table_name = "ahoy_events"

  belongs_to :visit
  belongs_to :user, optional: true
end
