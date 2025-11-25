class AppVersion < ApplicationRecord

  has_many :devices
  has_many :traceability_admins, dependent: :destroy

  validates :version_movil, :description, presence: true

  # Archivos carrierwave
  mount_uploader :apk_file, ApkFileUploader

  attr_accessor :action
  attr_accessor :admin

  after_save :management_admin
    
  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_version: true, app_version_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_version: true, app_version_id: self.id)
    end
  end
end
