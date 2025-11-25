class Injury < ApplicationRecord
  belongs_to :consultation, optional: true
  belongs_to :consultation_control, optional: true
  belongs_to :body_area
  has_many :images_injuries, inverse_of: 'injury'

  validates :body_area_id, presence: true, on: :create
  validate :validate_consulta?, on: [:create, :update]

  #Varias imagenes
  accepts_nested_attributes_for :images_injuries

  #Valida que la consulta o la consulta dle control debe ser obligatorio
  def validate_consulta?
    if self.consultation_id.nil? && self.consultation_control_id.nil?
      errors.add(:consult, "La consulta o el control del consulta no puede estar vacío")
    end 
  end
end
