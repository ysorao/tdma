class ClientUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :lockable, :validatable, :timeoutable

  belongs_to :client, optional: true
  has_many :search_patient_consults, class_name: 'TraceabilityConsult', foreign_key: 'seach_patient_id'
  has_many :search_patient_controls, class_name: 'TraceabilityControl', foreign_key: 'seach_patient_id'
  has_many :create_patients, class_name: 'TraceabilityClient', foreign_key: 'create_patient_id'
  has_many :traceability_clients
  has_many :traceability_admins, dependent: :destroy

  validates :number_document, :type_professional, :name, :surnames, :phone, :email, :client_id, presence: true, on: :create, unless: :create_user_web?
  validates :email, :number_document, :name, :surnames, :phone, :client_id, presence: true, on: :create, if: :create_user_web?
  validates_uniqueness_of :email, :number_document
  validates :email, format: { with: /\A[\w\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i }
  validates :password, :password_confirmation, length: { in: 6..30 }, unless: :condition_testing?
  #validate :password_complexity?
  #validate :validate_terms?, on: :create

  # Archivos carrierwave
  mount_base64_uploader :photo, PhotoClientUploader
  attr_accessor :commit
  attr_accessor :photo_cache
  attr_accessor :action
  attr_accessor :admin

  before_create :extra_information
  after_save :management_admin
    
  def extra_information
    if self.commit == 'web'
      self.role = 2
    elsif self.commit == 'app'
      self.role = 2
    else
      self.role = 1
    end
    if self.commit == 'web'
      self.password = self.number_document.to_s + 'aA'
      self.password_confirmation = self.number_document.to_s + 'aA'
    end
    self.commit == 'app' ? self.status = 1 : self.status = 0
  end

  def management_admin
    if self.action == "new" || self.action == "create"
      TraceabilityAdmin.create(admin_user_id: self.admin, create_user_client: true, client_user_id: self.id)   
    elsif self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_user_client: true, client_user_id: self.id)
    end
  end

  #Estados
  INACTIVO = 0
  ACTIVO = 1

  #Tipo profesional
  ADMIN_IPS = 1
  ESE = 2
  PROFESIONAL_INDEPENDIENTE = 3

  #Rol
  ADMIN = 1
  AUXILIAR = 2

  #Confirma si el registro de un usuario del cliente viene desde la web
  def create_user_web?
    self.commit == 'web'
  end

  # Metodo: Solo valida las contraseñas
  def condition_testing?
    (self.password.nil? && self.password_confirmation.nil?)
  end

  # Método: Para validar la complejidad de una contraseña
	#def password_complexity?
		#if password.present?
		  #if !password.match(/^(?=\w*\d)(?=\w*[A-Z])(?=\w*[a-z])/)
		    #errors.add(:password, "debe incluir al menos una letra minúscula, una letra mayúscula y un número.")
		  #end
		#end
	#end

  #Valida los terminos y condiciones
  def validate_terms?
    if self.terms_and_conditions == false
      errors.add(:terms_and_conditions, "debe aceptar los terminos y condiciones")
    end
  end
end
