class NurseConsultation < ApplicationRecord
  belongs_to :consultation, optional: true

  validates :ulcer_etiology, :pain_intensity, :weight, :ulcer_length, :ulcer_width, :ulcer_handle, presence: true
  validate :validate_ulcer_etiology_other?
  validate :validate_ulcer_handle_aposito?
  validate :validate_ulcer_handle_other?
  validate :validate_exams?
  #CONSTANTES

  #Diagnostico etimologico de la ulcera (ulcer_etiology)
  VENOSA = 1
  ARTERIAL = 2
  DIABETES = 3
  ULCERA_PRO_PRESION = 4
  NEUROPATICA = 5
  OTRA = 6
  SIN_DIAGNOSTICO = 7

  #Signos de infección (infection_signs)
  INFLAMACION = 1
  OLOR_FETIDO = 2
  EXUDADO_PURULENTO = 3
  AUMENTO_RECIENTE_DOLOR = 4

  #Tejido de la herida (wound_tissue)
  TEJIDO_GRANULACION = 1
  FIBRINA = 2
  TEJIDO_NECROTICO = 3
  HIPERGRANULACION = 4
  CICATRIZACION_COMPLETA = 5
  COSTRA = 6

  #Pulses (Pulsos)
  AUSENTE = 1
  DEBIL = 2
  NORMAL = 3

  #Piel alrededor de la ulcera (skin_among_ulcer)
  DERMATITIS = 1
  FIBROSIS = 2

  #Manejo de ulcera (ulcer_handle)
  MEDIDAS_COMPRESION = 1
  LAVADO_SSN = 2
  GASAS_VASELINADAS = 3
  COLAGENASA = 4
  APOSITO = 5
  OTRO = 6

  #Valida que el audio fisico o la descripcion debe ser obligatorio
  def validate_exams?
    if self.consultation_reason_description.blank? && self.consultation_reason_audio.blank?
      errors.add(:exam, "audio o descripción no puede estar vacío")
    end 
  end

  #Valida el campo que sea solo obligatorio si se escoge la opcion otra
	def validate_ulcer_etiology_other?
		if self.ulcer_etiology.to_i == NurseConsultation::OTRA && self.ulcer_etiology_other.blank?
			errors.add(:ulcer_etiology_other, "es obligatorio")
		end
	end

	#Valida el campo que sea solo obligatorio si se escoge la opcion otro
	def validate_ulcer_handle_aposito?
		if self.ulcer_handle.to_i == NurseConsultation::APOSITO && self.ulcer_handle_aposito.blank?
			errors.add(:ulcer_handle_aposito, "es obligatorio")
		end
	end

	#Valida el campo que sea solo obligatorio si se escoge la opcion otro
	def validate_ulcer_handle_other?
		if self.ulcer_handle.to_i == NurseConsultation::OTRO && self.ulcer_handle_other.blank?
			errors.add(:ulcer_handle_other, "es obligatorio")
		end
	end
end
