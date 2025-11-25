class MedicalControl < ApplicationRecord
  belongs_to :consultation_control
  belongs_to :control_doctor, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :consultation, optional: true
  has_many :images_injuries

  validates :subjetive_improvement, :tolerated_medications, presence: true
  validate :validate_exams?

  # Archivos carrierwave
  #mount_base64_uploader :audio_clinic, AudioClinicControlUploader
  #mount_base64_uploader :audio_annex, AudioAnnexControlUploader
  #mount_base64_uploader :annex_photo, AnnexPhotoControlUploader

  #Atributo virtual para traer el email del usuario en sesión
  attr_accessor :usuario

  before_create :extra_information
    
  def extra_information
    self.status = 1

    user = User.find_by_authentication_token(self.usuario)
    unless user.nil?
      if user.type_professional == User::MEDICO
        self.doctor_id = user.id
      end
    end
  end

  #tolerated_medications
  SÍ = 1
  NO = 2
  NO_SE_FORMULARON = 3

  #Status (Estado)
  INACTIVO = 0
  ACTIVO = 1

  #Valida en el Examen fisico: el audio o la descripcion deben ser obligatorios
  def validate_exams?
    if self.audio_clinic.blank? && self.clinic_description.blank? && self.audio_annex.blank? && self.annex_description.nil?
      errors.add(:exam, "audio, descripción o imagen no puede estar vacío")
    end
  end

  #Todas los controles del cliente de los pacientes por aseguradora
  def self.control_medical(client, aseguradora, estados)
    includes({consultation_control: [patient: :patient_informations]}).where("patients.client_id = ? AND patient_informations.insurance_id = ? AND consultation_controls.status IN (?)", client, aseguradora, estados).references({consultation_control: [patient: :patient_informations]})
  end

  #Permite mostrar los controles que se le han hecho a un paciente
  def self.patient_medical_control(patient)
    includes(:consultation_control).where("consultation_controls.patient_id = ? AND consultation_controls.status != ?", patient, Consultation::EVALUANDO).references(:consultation_control).order(created_at: :asc)
  end
end
