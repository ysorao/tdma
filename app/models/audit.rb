class Audit < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device, optional: true

  validates :description, :date_action, :user_id, :device_id, presence: true
end
