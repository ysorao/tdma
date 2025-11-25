class DesignedResponse < ApplicationRecord

  has_many :contacts

  validates :title, :description, :status, presence: true

  #validates_length_of :description, maximum: 120, message: "Solo se permiten 120 caracteres"

  #ESTADOS
  INACTIVO = 0
  ACTIVO = 1
end
