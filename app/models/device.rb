class Device < ApplicationRecord
  belongs_to :app_version, optional: true
  belongs_to :kit, optional: true
  has_many :help_desks
  has_many :payment_histories
  has_many :audits
  has_many :traceability_admins, dependent: :destroy

  validates :imei, :app_version_id, :cell_brand, :system_version, presence: true
  validates :imei, length: { maximum: 40 }
  validates_uniqueness_of :imei

  attr_accessor :action
  attr_accessor :admin

  after_save :management_admin
    
  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_device: true, device_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_device: true, device_id: self.id)
    end
  end
end
