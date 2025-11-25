class Bill < ApplicationRecord
  belongs_to :contract, optional: true
  has_many :traceability_admins, dependent: :destroy

  validates :contract_id, :bill_file, :code, :date_expedition, presence: true

  # Archivos carrierwave
  mount_uploader :payment_file, PaymentFileUploader
  mount_uploader :bill_file, BillFileUploader

  attr_accessor :action
  attr_accessor :admin

  after_save :management_admin
    
  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_bill: true, bill_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_bill: true, bill_id: self.id)
    end
  end
end
