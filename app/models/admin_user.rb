class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  has_many :help_desks
  has_many :traceability_admins
  has_many :user_admins, class_name: 'TraceabilityAdmin', foreign_key: 'user_admin_id'
  has_many :contacts

  validates :email, :name, :surnames, :number_document, :phone, :password, :password_confirmation, :role, presence: true
  validates_uniqueness_of :email, :number_document

  attr_accessor :action
  attr_accessor :admin

  #Estado
  INACTIVO = 0
  ACTIVO = 1

  #Roles
  SUPER_ADMIN = 1
  ADMIN = 2
  SOPORTE_TECNICO = 3

  after_save :management_admin

  def management_admin
    if self.action == "edit"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_admin: true, user_admin_id: self.id)
    end
  end
  # Ransack 4.x - required for ActiveAdmin
  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "name", "surnames", "number_document", "phone", "role", "status", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["contacts", "help_desks", "traceability_admins", "user_admins"]
  end

end
