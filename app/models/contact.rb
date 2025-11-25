class Contact < ApplicationRecord

  belongs_to :admin_user, optional: true
  belongs_to :designed_response, optional: true	
  has_many :traceabilityAdmins

  validates :name_complete, :email, :phone, presence: true

  #TIPO
  VENTAS = 1
  SOPORTE = 2

  #Estados
  PENDIENTE = 1
  EVALUANDO = 2
  RESUELTO = 3
end
