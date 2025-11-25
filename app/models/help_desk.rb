class HelpDesk < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :device, optional: true
  belongs_to :admin_user, optional: true
  has_many :history_tickets
  has_many :traceability_admins, dependent: :destroy

  validates :subject, :description, :ticket, :status, :user_id, :device_id, presence: true, on: :create
  validates :response_ticket, :status, presence: true, on: :update

  validates :image_user, :image_admin, allow_blank: true, format: {with: %r{\.gif|jpg|png|jpeg}i, message: 'Debe ser una archivo tipo imagen gif, jpg, png o jpeg.'}, on: :update

  # Archivos carrierwave
  mount_uploader :image_user, FileImageUserUploader
  mount_uploader :image_admin, FileImageAdminUploader
  attr_accessor :action
  attr_accessor :admin

	#Estados
  PENDIENTE = 1
  EVALUANDO = 2
  RESUELTO = 3
end
