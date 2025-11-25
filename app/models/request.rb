class Request < ApplicationRecord
  belongs_to :consultation, optional: true
  belongs_to :consultation_control, optional: true
  belongs_to :specialist_request, class_name: 'User', foreign_key: 'specialist_id', optional: true
  belongs_to :doctor_request, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :nurse_request, class_name: 'User', foreign_key: 'nurse_id', optional: true
  has_many :request_images

  validates :status, presence: true, on: :create
  validate :validate_type_request?
  validate :validate_reason?, on: :update, if: :type?

  # Archivos carrierwave
  #mount_base64_uploader :audio_request, AudioRequestUploader

  attr_accessor :type

  #Status
  PENDIENTE = 1
  RESUELTO = 2

  #Motivo
  NO_REGRESO = 1  #El paciente no regreso
  ESTA_SANO = 2  #El paciente esta sano
  NO_RESUELTO = 3  #No fue posible resolver la solicitud

  #Pedirle a la movil que guarde los textos en un metodo
  #Type request
  SE_REQUIEREN_IMAGENES = 1 #No fue posible responder la teleconsulta: Imágenes desenfocadas e insuficientes para el diagnóstico. Por favor repetirlas.
  IMAGENES_ZOOM = 2 #No fue posible responder la teleconsulta: No hay imágenes con acercamiento de la lesión. Por favor adicionar imágenes con zoom. 
  IMAGENES_PERPENDICULARES = 3 #No fue posible responder la teleconsulta: Se requieren imágenes perpendiculares de la lesión. Por favor adicionarlas.
  EXAMEN_FISICO_IMCOMPLETO = 4 #No fue posible responder la teleconsulta: Examen físico incompleto. Por favor describir mejor el tipo de lesión, distribucción y localización.
  OTRO = 5 #Otro


  def type?
    self.type == "1"
  end

  def validate_reason?
    if self.reason.nil? && self.other_reason.blank?
      errors.add(:reason, "Debe seleccionar un motivo o otro")
    end
  end

  def validate_type_request?
    if self.type_request.nil?
      errors.add(:type_request, "Debe seleccionar uno de la lista desplegable.")    
    end
  end
end
