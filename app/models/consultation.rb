class Consultation < ApplicationRecord
  belongs_to :patient, optional: true
  belongs_to :patient_information, optional: true
  belongs_to :specialist, class_name: 'User', foreign_key: 'specialist_id', optional: true
  belongs_to :assistant, class_name: 'User', foreign_key: 'assistant_id', optional: true
  belongs_to :doctor, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :nurse, class_name: 'User', foreign_key: 'nurse_id', optional: true
  belongs_to :user_assign, class_name: 'User', foreign_key: 'assign_id', optional: true
  has_many :injuries
  has_many :medical_controls
  has_many :specialist_responses
  has_many :requests
  has_many :annex_images
  has_many :consultation_controls
  has_one :medical_consultation
  has_one :nurse_consultation
  has_many :payment_histories
  has_many :traceability_consults
  has_many :traceability_admins

  #validates :evolution_injuries, :evolution_time, :unit_measurement, :symptom, :change_symptom, :patient_information_id, presence: true, on: :create 
  #validates :evolution_time, length: { in: 1..4 }, on: :create
  validates :patient_information_id, presence: true, on: :create
  validate :validate_remission?, on: :update
  #validate :validate_obvious_changes?, on: :create
  #validate :validate_exams?, on: :update

  # Archivos carrierwave
  #mount_base64_uploader :audio_annex, AudioAnnexConsultantUploader
  #mount_base64_uploader :physical_audio, PhysicalAudioConsultantUploader

  #accepts_nested_attributes_for :other_diagnostics

  #Atributo virtual para traer el email del usuario en sesión
  attr_accessor :usuario

  #Atributo virtual para diferenciar entre examen fisico y anexos
  #attr_accessor :tipo

  before_create :extra_information
	  
	def extra_information
    self.status = -1
    self.date_archived = ""

    patient = PatientInformation.find(self.patient_information_id)
    self.patient_id = patient.patient_id
    self.patient_information_id = self.patient_information_id

    user = User.find_by_authentication_token(self.usuario)
    if user.type_professional == User::MEDICO
      self.doctor_id = user.id
      self.type_profesional = User::MEDICO
    elsif user.type_professional == User::ENFERMERA
      self.nurse_id = user.id
      self.type_profesional = User::ENFERMERA
    end
	end

  #CONSTANTES

  #Status (Estado)
  RESUELTO = 1
  REQUERIMIENTO = 2
  PENDIENTE = 3
  ARCHIVADO = 4
  PROCESO = 5
  SIN_CREDITOS = 6
  REMISION = 7
  EVALUANDO = 8

  #type
  MEDICO = 1
  ENFERMERA = 2

  #Valida los terminos y condiciones
  def validate_remission?
    unless self.status == 6
      if self.type_remission.nil?
        errors.add(:type_remission, "Debe seleccionar uno de la lista")
      elsif self.remission_comments.nil?
        errors.add(:remission_comments, "No puede ser vacío")
      end
    end
  end

  #Metodo que permite revisar las consultas que tiene un especialista para asignarle la siguiente
  def self.pending_consults(user)
    pending = []
    consult = Consultation.specialist_status(user, Consultation::EVALUANDO, User::DERMATOLOGO)
    control = ConsultationControl.specialist_status(user, Consultation::EVALUANDO, User::DERMATOLOGO)
    consultas = (consult + control).map {|x| pending.push(x.id)}.flatten.uniq
    pending
  end

  #Metodo que permite revisar las consultas que tiene una enfermera para asignarle la siguiente
  def self.pending_nurse_consults(user)
    nurse_pending = []
    consult = Consultation.specialist_status(user, Consultation::EVALUANDO, User::ENFERMERIA)
    control = ConsultationControl.specialist_status(user, Consultation::EVALUANDO, User::ENFERMERIA)
    consultas = (consult + control).map {|n| nurse_pending.push(n.id)}.flatten.uniq
    nurse_pending
  end

  #Metodo que trae todos los estados de sus consultas de un paciente
  def self.consult_status(patient_id)
    where(patient_id: patient_id).sort.pluck(:status)
  end

  #Metodo que muestra la información del especialista segun su estado
  def self.specialist_status(user, status, type)
    includes(:specialist).where("consultations.specialist_id = ? AND consultations.status IN (?) AND users.type_specialist = ?", user, status, type).order(created_at: :asc).references(:specialist)
  end

  #Metodo que muestra la información del o los especialistas segun su estado
  #def self.specialists_status(user, status, type)
    #includes(:specialist).where("consultations.specialist_id IN (?) AND consultations.status IN (?) AND users.type_specialist = ?", user, status, type).order(created_at: :asc).references(:specialist)
  #end

  #Devuelve el tipo de remisión segun si es consulta o control
  def self.remission_consult(option)
    case option
      when 1
        type = 'Cuadro clínico complejo para evaluar por teledermatología. Favor remitir el paciente a dermatólogo presencial.'
      when 2
        type = 'Se requiere valoración por otra especialidad diferente a dermatología. Favor remitir el paciente a la especialidad correspondiente.'
      when 3
        type = 'Otro'
    end
  end

  #Devuelve el tipo de remisión segun si es consulta o control de enfermería
  def self.nurse_remission_consult(option)
    case option
      when 1
        type = 'Cuadro clínico complejo para evaluar por teledermatología. Favor remitir el paciente a dermatólogo presencial.'
      when 2
        type = 'Se requiere valoración por otra especialidad diferente a dermatología. Favor remitir el paciente a la especialidad correspondiente.'
    end 
  end

  #Validar campos del modelo
  def has_anex?
    has_anex = false
    has_anex = true if self.annex_images.count > 0
    has_anex = true unless self.annex_description.blank?
    has_anex = true unless self.audio_annex.blank?
    return has_anex
  end

  #Metodo que permite devolver las consultas de un paciente con los estados
  #(Resuelto, Requerimiento, Pendiente, Remisión)
  def self.consults_patient(buscar)
    #includes(:patient).where("(unaccent(LOWER(patients.name)) ILIKE('%#{buscar.parameterize.underscore.humanize.downcase}%') OR unaccent(LOWER(patients.second_name)) ILIKE('%#{buscar.parameterize.underscore.humanize.downcase}%') OR unaccent(LOWER(patients.last_name)) ILIKE('%#{buscar.parameterize.underscore.humanize.downcase}%') OR patients.number_document = ?) AND consultations.status IN (?)", buscar, [1,2,7]).references(:patient)
    includes(:patient).where("((patients.name || ' ' || patients.second_name || ' ' || patients.last_name || ' ' || patients.second_surname) ILIKE ? OR (patients.name || ' ' || patients.last_name || ' ' || patients.second_surname) ILIKE ? OR patients.number_document = ?) AND consultations.status IN (?)", "%#{buscar.parameterize.underscore.humanize.downcase}%", "%#{buscar.parameterize.underscore.humanize.downcase}%", buscar, [1,2,3,7]).references(:patient)
  end

  #Permite traer todas las consultas de un cliente en estado sin creditos
  def self.consults_without_credits(estado, cliente)
    includes(doctor: :user_clients).where("consultations.status = ? AND user_clients.client_id = ?", estado, cliente).references(user: :user_clients).order(:id)
  end

  #Filtro de activeadmin (administración) donde las consultas se muestran por IPS
  ransacker :vendor, formatter: proc { |consult_id|
    results = Consultation.includes(doctor: :user_clients).where("user_clients.client_id = ?", consult_id).references(doctor: :user_clients).order(id: :desc).pluck(:id)
    results = results.present? ? results : nil
  }, splat_params: true do |parent|
     parent.table[:id]
  end

  #Permite listar las consultas por CIE10
  def self.search_consults_disease(word)
    enferm = Disease.find_by(name: word)
    cons = SpecialistResponse.order(:created_at).where("consultation_id IS NOT NULL").pluck(:id)
    cont = SpecialistResponse.order(:created_at).where("consultation_control_id IS NOT NULL").pluck(:id)
    consultas_diag = OtherDiagnostic.where("specialist_response_id IN (?)", cons).order(:created_at).uniq(&:specialist_response_id)
    controles_diag = OtherDiagnostic.where("specialist_response_id IN (?)", cont).order(:created_at).uniq(&:specialist_response_id)
    consultas = Consultation.includes({specialist_responses: :other_diagnostics}).where("other_diagnostics.id IN (?) AND other_diagnostics.disease_id = ?", consultas_diag, enferm.id).order(created_at: :desc).references({specialist_responses: :other_diagnostics})
    controles = ConsultationControl.includes({specialist_responses: :other_diagnostics}).where("other_diagnostics.id IN (?) AND other_diagnostics.disease_id = ?", controles_diag, enferm.id).order(created_at: :desc).references({specialist_responses: :other_diagnostics})
    teleconsultas = (consultas + controles)
    #diagnosticos = OtherDiagnostic.all.uniq(&:specialist_response).pluck(:id)
    #consultas, aux = Consultation.includes({specialist_responses: :other_diagnostics}).where("other_diagnostics.specialist_response_id IN (?) AND other_diagnostics.disease_id = ?", cons, enferm.id).order(created_at: :desc).references({specialist_responses: :other_diagnostics}), []
    #consultas.map {|x| aux.push({consulta: x, controles: [x.consultation_controls.includes({specialist_responses: :other_diagnostics}).where("other_diagnostics.specialist_response_id IN (?) AND other_diagnostics.disease_id = ?", cont, enferm.id).order(created_at: :desc).references({specialist_responses: :other_diagnostics})]})} 
    #controles = aux[0..aux.length].blank? ? 0 : aux[0..aux.length].flatten.map {|x| x[:controles].flatten.count}.max
    #[aux, (aux.count + controles)]
  end
end
