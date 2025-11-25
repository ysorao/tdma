class SystemManual < ApplicationRecord
  has_many :traceability_admins, dependent: :destroy

  validates :name, :file_manual, :type_manual, presence: true

  # Archivos carrierwave
  mount_uploader :file_manual, FileManualUploader

  #Tipos de manual
  ESPECIALISTA = 1
  IPS = 2
  APP = 3
  LANDING = 4

  attr_accessor :action
  attr_accessor :admin

  after_save :management_admin
    
  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_manual_system: true, system_manual_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_manual_system: true, system_manual_id: self.id)
    end
  end
end
