class ConsultationControl < ApplicationRecord
  belongs_to :consultation, optional: true
  belongs_to :patient, optional: true
  belongs_to :specialist_control, class_name: 'User', foreign_key: 'specialist_id', optional: true
  belongs_to :assistant_control, class_name: 'User', foreign_key: 'assistant_id', optional: true
  belongs_to :doctor_control, class_name: 'User', foreign_key: 'doctor_id', optional: true
  belongs_to :nurse_control, class_name: 'User', foreign_key: 'nurse_id', optional: true
  belongs_to :user_assign_control, class_name: 'User', foreign_key: 'assign_id', optional: true
  has_many :annex_images
  has_one :medical_control
  has_one :nurse_control
  has_many :payment_histories
  has_many :specialist_responses
  has_many :injuries
  has_many :requests
  has_many :traceability_controls
  has_many :traceability_admins

  validates :consultation_id, presence: true, on: :create

  attr_accessor :usuario

  before_create :extra_information
    
  def extra_information
    user = User.find_by_authentication_token(self.usuario)

    unless user.nil?
      if user.type_professional == User::MEDICO
        self.doctor_id = user.id
      elsif user.type_professional == User::ENFERMERA
        self.nurse_id = user.id
      end
    end
  end

  #CONSTANTES
  
  #type
  MEDICO = 1
  ENFERMERA = 2

  #Metodo que muestra la información del especialista segun su estado
  def self.specialist_status(user, status, type)
    includes(:specialist_control).where("consultation_controls.specialist_id = ? AND consultation_controls.status IN (?) AND users.type_specialist = ?", user, status, type).order(created_at: :asc).references(:specialist_control)
  end

  #Metodo que trae todos los estados de sus consultas de un paciente
  def self.consult_status(patient_id)
    where(patient_id: patient_id).sort.pluck(:status)
  end

  #Metodo que permite devolver los controles de un paciente con los estados
  #(Resuelto, Requerimiento, Pendiente, Remisión)
  def self.controls_patient(buscar)
    includes(:patient).where("(unaccent(LOWER(patients.name)) ILIKE('%#{buscar.parameterize.underscore.humanize.downcase}%') OR patients.number_document = ?) AND consultation_controls.status IN (?)", buscar, [1,2,7]).references(:patient)
  end

  #Permite traer todos los controles de un cliente en estado sin creditos
  def self.controls_without_credits(estado, cliente)
    includes(doctor_control: :user_clients).where("consultation_controls.status = ? AND user_clients.client_id = ?", estado, cliente).references(user: :user_clients).order(:id)
  end

  #Filtro de activeadmin (administración) donde los controles se muestran por IPS
  ransacker :vendor, formatter: proc { |control_id|
    results = ConsultationControl.includes(doctor_control: :user_clients).where("user_clients.client_id = ?", control_id).references(doctor_control: :user_clients).order(id: :desc).pluck(:id)
    results = results.present? ? results : nil
  }, splat_params: true do |parent|
     parent.table[:id]
  end
end
