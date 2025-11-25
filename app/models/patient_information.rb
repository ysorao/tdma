class PatientInformation < ApplicationRecord
  belongs_to :municipality, optional: true
  belongs_to :patient
  belongs_to :insurance, optional: true
  has_many :consultations

  validates :civil_status, :age, :unit_measure_age, :municipality_id, :type_user, :purpose_consultation, :external_cause, presence: true
  #validates :email, format: { with: /\A[\w\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  #validates :phone, length: { in: 7..15 }
  #validates :age, length: { in: 1..3 }
  validates :age, numericality: { only_integer: true }
  validates :urban_zone, :presence => { :if => 'urban_zone.nil?' }
  validate :validate_terms?, on: :create
  #validate :validate_unit_measure_age?, on: :create

 
   before_create :extra_information
    
  def extra_information
    self.email.downcase!
    self.status = 5
    self.code_consultation = "89.0.3.42"
  end

  #CONSTANTES

  #Estado civil
  SOLTERO = 1
  CASADA = 2
  UNIÓN_LIBRE = 3
  VIUDO = 4
  SEPARADO_DIVORCIADO = 5


  #Unidad de medida
  AÑOS = 1
  MESES = 2
  DÍAS = 3

  #Tipo usuario
  CONTRIBUTIVO = 1 
  SUBSIDIADO = 2
  VINCULADO = 3
  PARTICULAR = 4
  OTRO = 5
  VICTIMA_AFILIACION_REGIMEN_CONTRIBUTIVO = 6
  VICTIMA_AFILIACION_REGIMEN_SUBSIDIADO = 7
  VICTIMA_NO_ASEGURADO = 8

  #Finalidad consulta
  NO_APLICA = 1
  ATENCION_PARTO = 2
  ATENCION_RECIEN_NACIDO = 3
  ATENCION_PLANIFICACION_FAMILIAR = 4
  DETECCION_ALTERACIONES_CRECIMIENTO_MENOS_DIEZ_AÑOS = 5
  DETECCION_ALTERACIONES_DESARROLLO_JOVEN = 6
  DETECCION_ALTERACIONES_CRECIMIENTO_MENOS_DIEZ_AÑOS_EMBARAZO = 7
  DETECCION_ALTERACIONES_ADULTO = 8
  DETECCION_ALTERACIONES_AGUDEZA_VISUAL = 9
  DETECCION_ENFERMEDAD_PROFESIONAL = 10

  #Causa externa
  ENFERMEDAD_GENERAL = 1
  ACCIDENTE_TRABAJO = 2
  ACCIDENTE_TRANSITO = 3
  ACCIDENTE_RABICO = 4
  ACCIDENTE_OFIDICO = 5
  OTRO_ACCIDENTE = 6
  EVENTO_CATASTROFICO = 7
  LESION_AGRESION = 8
  LESION_AUTOINFLIGIDA = 9
  SOSPECHA_MALTRATO_FISICO = 10
  SOSPECHA_ABUSO_SEXUAL = 11
  SOSPECHA_VIOLENCIA_SEXUAL = 12
  SOSPECHA_MALTRATO_EMOCIONAL = 13
  ENFERMEDAD_LABORAL = 14
  OTRA = 15

  #Zona urbana
  URBANA = 1
  RURAL = 2

	#Valida los terminos y condiciones
	def validate_terms?
		if self.terms_conditions == false || self.terms_conditions.nil?
			errors.add(:terms_conditions, "Debe aceptar los terminos y condiciones")
		end
	end

  #Método para validar la unidad de medida dependiendo de lo que se escoja para medir rangos (RIPS)
  def validate_unit_measure_age?
    if self.unit_measure_age == PatientInformation::AÑOS
      if self.age < 1 || self.age > 120
        errors.add(:age, "#{self.age} no está entre 1 a 120 años")
      end   
    elsif self.unit_measure_age == PatientInformation::MESES
      if self.age < 1 || self.age > 11
        errors.add(:age, "#{self.age} no está entre 1 a 11 meses")
      end
    elsif self.unit_measure_age == PatientInformation::DÍAS
      if self.age < 1 || self.age > 29
        errors.add(:age, "#{self.age} no está entre 1 a 29 días")
      end
    end
  end
end
