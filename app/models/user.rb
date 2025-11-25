class User < ApplicationRecord

  acts_as_token_authenticatable
  # Include default devise modules. Others available are:
  # :confirmable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :lockable, :validatable, :timeoutable #:confirmable

  belongs_to :subsidiary, optional: true
  has_many :specialists, class_name: 'Consultation', foreign_key: 'specialist_id'
  has_many :specialists_library, class_name: 'LibrarySpecialist', foreign_key: 'specialist_id'
  has_many :specialist_request_exams, class_name: 'RequestExam', foreign_key: 'specialist_id'
  has_many :assistants, class_name: 'Consultation', foreign_key: 'assistant_id'
  has_many :doctors, class_name: 'Consultation', foreign_key: 'doctor_id'
  has_many :nurses, class_name: 'Consultation', foreign_key: 'nurse_id'
  has_many :doctor_controls, class_name: 'MedicalControl', foreign_key: 'doctor_id'
  has_many :specialist_responses, class_name: 'SpecialistResponse', foreign_key: 'specialist_id'
  has_many :nurse_responses, class_name: 'SpecialistResponse', foreign_key: 'nurse_id'
  has_many :specialist_requests, class_name: 'Request', foreign_key: 'specialist_id'
  has_many :doctor_requests, class_name: 'Request', foreign_key: 'doctor_id'
  has_many :nurse_requests, class_name: 'Request', foreign_key: 'nurse_id'
  has_many :user_assigns, class_name: 'Consultation', foreign_key: 'assign_id'
  has_many :specialist_controls, class_name: 'ConsultationControl', foreign_key: 'specialist_id'
  has_many :assistants_controls, class_name: 'ConsultationControl', foreign_key: 'assistant_id'
  has_many :doctors_controls, class_name: 'ConsultationControl', foreign_key: 'doctor_id'
  has_many :nurses_controls, class_name: 'ConsultationControl', foreign_key: 'nurse_id'
  has_many :user_assign_controls, class_name: 'ConsultationControl', foreign_key: 'assign_id'
  has_many :doctor_trace_consults, class_name: 'TraceabilityConsult', foreign_key: 'doctor_id'
  has_many :doctor_trace_controls, class_name: 'TraceabilityControl', foreign_key: 'doctor_id'
  has_many :assign_consults, class_name: 'TraceabilityConsult', foreign_key: 'assign_consult_id'
  has_many :assign_controls, class_name: 'TraceabilityControl', foreign_key: 'assign_control_id'
  has_many :reassign_consults, class_name: 'TraceabilityConsult', foreign_key: 'reassign_consult_id'
  has_many :reassign_controls, class_name: 'TraceabilityControl', foreign_key: 'reassign_control_id'
  has_many :response_req_consults, class_name: 'TraceabilityConsult', foreign_key: 'response_req_id'
  has_many :reject_reqs_consults, class_name: 'TraceabilityConsult', foreign_key: 'reject_req_id'
  has_many :view_consults, class_name: 'TraceabilityConsult', foreign_key: 'view_consult_id'
  has_many :patient_specialist_consults, class_name: 'TraceabilityConsult', foreign_key: 'patient_specialist_id'
  has_many :response_req_controls, class_name: 'TraceabilityControl', foreign_key: 'response_req_id'
  has_many :reject_reqs_controls, class_name: 'TraceabilityControl', foreign_key: 'reject_req_id'
  has_many :view_controls, class_name: 'TraceabilityControl', foreign_key: 'view_consult_id'
  has_many :patient_specialist_controls, class_name: 'TraceabilityControl', foreign_key: 'patient_specialist_id'
  has_many :assign_consult_admins, class_name: 'TraceabilityAdmin', foreign_key: 'assign_consult_id'
  has_many :reassign_consult_admins, class_name: 'TraceabilityAdmin', foreign_key: 'reassign_consult_id'
  has_many :assign_control_admins, class_name: 'TraceabilityAdmin', foreign_key: 'assign_control_id'
  has_many :reassign_control_admins, class_name: 'TraceabilityAdmin', foreign_key: 'reassign_control_id'

  has_many :help_desks
  has_many :user_clients
  has_many :audits
  has_many :traceability_admins, dependent: :destroy

  #Validacion en la movil
  validates :number_document, :type_professional, :name, :surnames, :phone, :email, :password, :terms_and_conditions, presence: true, on: :create, unless: :create_user_admin?
  #Validacion en IPS
  #validates :name, :surnames, :number_document, :type_professional, :professional_card, :phone, :email, :password, :password_confirmation, presence: true, on: :create, if: :create_user_web?
  #Validacion en el admin
  validates :name, :surnames, :number_document, :type_professional, :professional_card, :phone, :email, :terms_and_conditions, :password, :password_confirmation, presence: true, on: :create, if: :create_user_admin?
  validates :name, :surnames, :phone, :email, :image_digital, presence: true, on: :update, if: :condition_testing?
  validates :name, :surnames, :number_document, :type_professional, :type_specialist, :professional_card, :phone, :email, :password, :password_confirmation, presence: true, on: :update, if: :specialist?
  validates_uniqueness_of :email
  validates_uniqueness_of :number_document, unless: :create_user_web?
  validates :email, format: { with: /\A[\w\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, :password_confirmation, length: { in: 6..30 }, unless: :condition_testing?
  #validate :password_complexity?, on: [:create, :update]
  validate :type_profesional?, on: :create
  validate :validate_terms?, on: :create
  validate :validate_type_specialist?, on: :create, if: :create_user_admin?

	# Archivos carrierwave
	mount_base64_uploader :photo, PhotoUserUploader
  mount_base64_uploader :image_digital, ImageDigitalUserUploader

  #Atributo virtual para diferenciar entre web y api y usar la validacion que corresponde
  attr_accessor :commit
  attr_accessor :photo_cache
  attr_accessor :action
  attr_accessor :admin

	#VALID_EMAIL_REGEX = /\A[\w\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  
  #Estados
  INACTIVO = 0
  ACTIVO = 1

  #Tipo profesional
  MEDICO = 1
  ENFERMERA = 2
  AUXILIAR = 3
  ESPECIALISTA = 4

  #Tipo de especialista
  DERMATOLOGO = 1
  ENFERMERIA = 2

  before_create :extra_information
  after_save :management_admin
	
  def self.users_specialist
      where.not(type_specialist: nil)
  end

  def self.users_doctor
      where(type_professional: User::MEDICO)
  end


	def extra_information
	  self.ensure_authentication_token
	  self.email.downcase!
	  self.status = 1
	end

  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_user: true, user_id: self.id)  
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_user: true, user_id: self.id)
    end
  end

  #Confirma si el registro de un usuario viene desde la web
  def create_user_web?
    self.commit == 'web'
  end

  #Confirma y valida si el registro viene de la administracion
  # (@new_record variable de instancia del admin)
  def create_user_admin?
    @new_record == true
  end

	#Valida los terminos y condiciones
	def validate_terms?
		if self.terms_and_conditions == false
			errors.add(:terms_and_conditions, "debe aceptar los terminos y condiciones")
		end
	end

	# Método: Para validar la complejidad de una contraseña
	def password_complexity?
    if password.present?
      if !password.match(/^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])/)
        errors.add(:password, "debe incluir al menos una letra minúscula, una letra mayúscula y un número.")
      end
    end
	end

	# Método: Para validar segun el tipo de profesional
	def type_profesional?
    if self.type_professional == User::MEDICO || self.type_professional == User::ENFERMERA || self.type_professional == User::ESPECIALISTA
			if self.professional_card.empty?
			  errors.add(:professional_card, "no puede estar vacío")
			end
		end
	end

  # Metodo: Solo valida las contraseñas
  def condition_testing?
    (self.password.nil? && self.password_confirmation.nil?)
  end

  #Metodo que valida si es un espcialista para poder editar su perfil en al web
  def specialist?
    self.type_professional == User::ESPECIALISTA
  end

  #Metodo que valida que si se escoge un especialista especifique de que area de medicina es
  def validate_type_specialist?
    if self.type_professional == User::ESPECIALISTA || self.type_professional == nil
      if self.type_specialist.blank?
        errors.add(:type_specialist, "debe seleccionar uno de la lista")
      end
    end
  end

  #Permite verificar si la cuenta del usuario esta activada
  def active_for_authentication?
    status == 1
  end

  #Devuelve los pacientes atendidos por especialista
  def self.attended(specialist_id)
    c = Consultation.where(specialist_id: specialist_id, status: [Consultation::RESUELTO, Consultation::REQUERIMIENTO, Consultation::REMISION]).count
    co = ConsultationControl.where(specialist_id: specialist_id, status: [Consultation::RESUELTO, Consultation::REQUERIMIENTO, Consultation::REMISION]).count
    return c + co
  end

  #Metodo que permite verificar desactivar los usuarios del cliente
  def self.user_contract(cliente, estado)
    includes(:user_clients).where("user_clients.client_id = ?", cliente).references(:user_clients).map{|x| x.update_attribute(:status, estado)}
  end
end
