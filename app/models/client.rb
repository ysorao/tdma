class Client < ApplicationRecord

  belongs_to :municipality, optional: true
  has_many :client_users, dependent: :destroy
  has_many :contracts
  has_many :ips_insurances, dependent: :destroy
  has_many :prepay_card_clients
  has_many :subsidiaries
  has_many :user_clients
  has_many :patients
  has_many :bills_insurances
  has_many :additional_cards
  has_many :traceability_consults
  has_many :traceability_admins, dependent: :destroy

  validates :status, :email, :identification_number, :type_identification, :business_name, :code_service_provider, :municipality_id, presence: true
  validates :code_service_provider, length: { is: 12 }
  validates :identification_number, length: { in: 1..16 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  #, :business_name, :bill_number, :bill_expedition_date, :administrator_entity_code, :administrator_entity_name, :benefits_plan, :policy_number, :total_value_shared_payment, :commision_value, :total_value_discounts, :net_to_pay_contract_entity
  # Una cliente tiene asociada varias aseguradoras
  #accepts_nested_attributes_for :subsidiaries, allow_destroy: true
  #accepts_nested_attributes_for :ips_insurances, allow_destroy: true
  #accepts_nested_attributes_for :client_users, allow_destroy: true

  attr_accessor :action
  attr_accessor :admin

  #CONSTANTES

  #Type_identification
  CEDULA_CIUDADANIA = 1
  CEDULA_EXTRANJERIA = 2
  CARNE_DIPLOMATICO = 3
  PASAPORTE = 4
  PERMISO_ESPECIAL_PERMANENCIA = 5
  RESIDENTE_ESPECIAL_PAZ = 6
  NIT = 7

  #status
  INACTIVO = 0
  ACTIVO = 1

  after_save :management_admin
  
  def management_admin 
    if self.action == "edit" || self.action == "update"
      TraceabilityAdmin.create(admin_user_id: self.admin, update_client: true, client_id: self.id)
    end
  end

  #CONSULTAS

  #Valida si el usuario ha aceptado temrinos y condiciones y esta activo en el sistema
  def active_for_authentication?
    super && terms_and_conditions? && status == ClientUser::INACTIVO
  end

  #Permite validar si un dispositivo pertenece a un kit ya registrado
  def self.validate_kit(device)
    includes({contracts: :kits}).where("kits.device_id = ?", device.id).references({contracts: :kits}).first
  end

  #Permite verificar si un usuario del cliente(IPS) tiene creditos disponibles
  def self.enabled_credits(user)
    includes(:user_clients).where("user_clients.user_id = ?", user.id).references(:user_clients)
  end

  #Método encargado de devolver las siglas del tipo de documento
  def self.name_document(type_document)
    case type_document
      when 1
        'CC'
      when 2
        'CE'
      when 3
        'PA'
      when 4
        'CD'
      when 5
        'PE'
      when 6
        'RE'
      when 7
        'NI'
    end
  end

  def self.type_document(info)
    if info.type_identification == 1
      'Cédula de ciudadania'
    elsif info.type_identification == 2
      'Cédula de extranjería'
    elsif info.type_identification == 3
      'Carne diplomatico'
    elsif info.type_identification == 4
      'Pasaporte'
    elsif info.type_identification == 5
      'Permiso especial de permanencia'
    elsif info.type_identification == 6
      'Residencia especial de paz'
    else
      'NIT'
    end
  end

  #Permite convertir la información a un csv para la generacion de (CT - RIPS)
  def self.to_csv(cliente, num_consult, num_patient)
    CSV.generate do |csv|
      client = Client.find(cliente)
      cli = client.attributes
      af = {a: cli['code_service_provider'], b: Time.now.strftime("%d/%m/%y"), c: "AF#{Date.today.strftime('%m%Y')}", d: 1}
      ac = {a: cli['code_service_provider'], b: Time.now.strftime("%d/%m/%y"), c: "AC#{Date.today.strftime('%m%Y')}", d: num_consult}
      us = {a: cli['code_service_provider'], b: Time.now.strftime("%d/%m/%y"), c: "US#{Date.today.strftime('%m%Y')}", d: num_patient}
      csv << us.values
      csv << af.values
      csv << ac.values
    end
  end

  #Permite eliminar el contenido de la carpeta (Tarea programada)
  def self.pdf_temporal_files
    FileUtils.rm_rf(Dir['pdf_temp_files/*'])
  end

  #Permite revisar si un cliente se le acabo el saldo disponible de créditos
  # y en caso de volver a cargarlos cambiar sus consultas sin créditos a pendientes
  # (Tarea programada)
  def self.discount_credits
    #cliente = Client.where(status: Client::ACTIVO, id: 1).first
    where(status: Client::ACTIVO).each do |cliente|
      consultas = Consultation.consults_without_credits(Consultation::SIN_CREDITOS, cliente.id)
      controles = ConsultationControl.controls_without_credits(Consultation::SIN_CREDITOS, cliente.id)
      total = consultas + controles # 3
      creditos = cliente.available_credits # 1
      if creditos != 0
        descuento = creditos - total.count # -2
        cambio = total.count + descuento # 3 - (-2) = 1
        if descuento < 0
          cliente.update_attribute(:available_credits, 0) # 1 - 1 = 0
          total[0...cambio].each {|x| x.update_attribute(:status, Consultation::PENDIENTE)}
        else
          cliente.update_attribute(:available_credits, creditos - total.count)
          total[0..total.count].each {|x| x.update_attribute(:status, Consultation::PENDIENTE)}
        end  
      end 
    end
  end
end