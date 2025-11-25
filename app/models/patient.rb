class Patient < ApplicationRecord

  belongs_to :client, optional: true
  has_many :patient_informations
  has_many :consultations
  has_many :consultation_controls

  #Validacion para la móvil
  validates :type_document, :last_name, :name, :genre, presence: true
  #Validacion para la web
  validates :name, :last_name, :type_document, :genre, :client_id, presence: true, on: :create, if: :create_patient_web?

  validates_uniqueness_of :number_document
  #validates :number_document, length: { in: 5..15 }
  #validates :name, :last_name, :second_surname, length: { maximum: 30 }
  validates :number_document, numericality: { only_integer: true }, if: :validate_type_document?
  validate :validate_condition?, on: :create
  validate :validate_number_document?, on: :create
  validate :validate_type_condition?, on: :create
  validate :validate_number_inpec?, on: :create
  validate :validate_unit_measure_age?, on: :create, if: :create_patient_web?
  validate :validate_age?, on: :create, if: :create_patient_web?
  validate :validate_age_size?, on: :create, if: :create_patient_web?
  validate :validate_insurance?, on: :create, if: :create_patient_web?

  #Atributo virtual para traer el municipio del paciente
  attr_accessor :municipio

  #Atributo virtual para asignarle la ips a la que pertenece el usuario
  attr_accessor :cliente

  #Atributo virtual para saber que el guardado viene desde la web de la IPS
  attr_accessor :commit

  accepts_nested_attributes_for :patient_informations

  #CONSTANTES

  #TIPO DOCUMENTO
  CÉDULA_CIUDADANÍA = 1 #CC
  CÉDULA_EXTRANJERÍA = 2 #CE
  CARNÉ_DIPLOMÁTICO = 3 #CD
  PASAPORTE = 4 #PA
  SALVOCONDUCTO = 5 #SC
  PERMISO_ESPECIAL_PERMANENCIA = 6 #PE
  RESIDENTE_ESPECIAL_PARA_LA_PAZ = 7 #RE
  REGISTRO_CIVIL = 8 #RC
  TARJETA_DE_IDENTIDAD = 9 #TI
  CERTIFICADO_DE_NACIDO_VIVO = 10 #CN
  ADULTO_SIN_IDENTIFICAR = 11 #AS
  MENOR_SIN_IDENTIFICAR = 12 #MS

  #CONDICIÓN
  TERCERA_EDAD = 1  #Personas de la tercera edad en protección de ancianatos. (AS)
  INDIGENAS_MAYOR_EDAD = 2 #Indígenas mayores de edad (AS)
  HABITANTES_CALLE_MAYOR_EDAD = 3 #Habitantes de la calle mayores de edad. (AS)
  HABITANTES_CALLE_MENOR_EDAD = 4 #Habitantes de la calle menores de edad. (MS)
  MENOR_EDAD_ICBF = 5 #Menores de edad desvinculados del conflicto armado. Población infantil vulnerable bajo protección en instituciones diferentes al ICBF. Menores de edad bajo protección del ICBF. (MS) 
  INDIGENAS_MENOR_EDAD = 6 #Indígenas menores de edad (MS)
  MENOR_EDAD_NACIDO = 7 #Menor de edad recién nacido con edad menor o igual a un (1) mes. (MS) 
  VICTIMAS_MENOR_EDAD = 8  #Víctimas menores de edad  (MS)
  VICTIMAS_MAYOR_EDAD = 9  #Víctimas mayores de edad (AS)
  POBLACION_RECLUSA = 10  #Población Reclusa con identificación interna asignada por el Instituto Nacional Penitenciario y Carcelario – INPEC (AS/MS)

  #GÉNERO
  MASCULINO = 1
  FEMENINO = 2

  before_create :extra_information, unless: :create_patient_web? 
    
  def extra_information
    cliente = UserClient.includes(:user).where("users.authentication_token = ?", self.cliente).references(:user).first
    self.client_id = cliente.client_id
  end

  def validate_insurance?
    if self.patient_informations[0].insurance_id.nil?
      errors.add(:insurance_id, "es un autocompletar por lo tanto debe escoger una opción de la lista.")      
    else
      aseg = Insurance.find_by(id: self.patient_informations[0].insurance_id.to_s)
      if aseg.nil?
        errors.add(:insurance_id, "no existe la aseguradora")
      end
    end
  end

  def validate_type_condition?
    if self.type_document == Patient::ADULTO_SIN_IDENTIFICAR || self.type_document == Patient::MENOR_SIN_IDENTIFICAR
      document_condition(self.type_condition, self.municipio)
    end
  end

  #Dependiendo del tipo de condicion devuelve un valor en digitos junto a varias validaciones
  def document_condition(condition, municipio)
    if municipio.to_i == 0
      errors.add(:type_condition, "debe ingresar el municipio")  
    else
      m = Municipality.find(municipio)
      codigos = m.code_department.to_s + m.code.to_s

      type_digit  = Patient.where(type_document: 12, type_condition: 7).order(:id).pluck(:number_document)
      type_digits = Patient.where(type_document: [11,12], type_condition: [4,8,9])
      type_alpha = Patient.where(type_document: [11,12], type_condition: [1,2,3,5,6])
      charset = Array('A'..'Z') + Array('0'..'9')
      consecutive = Array.new(4) { charset.sample }.join

      if self.type_condition.to_i == Patient::MENOR_EDAD_NACIDO
        if type_digit.blank?
          if self.number_document.length == 7
            contador = "00000".next
          elsif self.number_document == 8
            contador = "0000".next
          elsif self.number_document == 10
            contador = "00".next
          end
        else
          if self.number_document.length == 7
            type_digit.map{|x| x.split("-")[0].length == 7 ? x[8..12].to_s == "99999" ? contador = "00001" : contador = x[8..12].next : ''}.reject(&:empty?).last
          elsif self.number_document.length == 8
            type_digit.map{|x| x.split("-")[0].length == 8 ? x[9..12].to_s == "9999" ? contador = "0001" : contador = x[9..12].next : ''}.reject(&:empty?).last
          elsif self.number_document.length == 10
            type_digit.map{|x| x.split("-")[0].length == 10 ? x[11..12].to_s == "99" ? contador = "01" : contador = x[11..12].next : ''}.reject(&:empty?).last
          end
        end
      #Permite manejar los consecutivos (digitos) dependiendo del estado de la condicion escogida
      elsif self.type_condition.to_i == Patient::HABITANTES_CALLE_MENOR_EDAD || self.type_condition.to_i == Patient::VICTIMAS_MENOR_EDAD || self.type_condition.to_i == Patient::VICTIMAS_MAYOR_EDAD
        if type_digits.blank?
          digitos = "0000".next
        else
          if type_digits.last.number_document.last(4).to_s == "9999" 
            digitos = "0000".next
          else
            digitos = type_digits.last.number_document.split(/[A-Z]/)[1].next
          end
        end
      end

      case condition
        when 1
          self.number_document = codigos + 'S' + consecutive #915000S0001
          consecutive_alpha(codigos, type_alpha, self.number_document, 'S', consecutive)
        when 2
          self.number_document = codigos + 'I' + consecutive #915000I0001
          consecutive_alpha(codigos, type_alpha, self.number_document, 'I', consecutive)
        when 3
          self.number_document = codigos + 'D' + consecutive #915000D0001
          consecutive_alpha(codigos, type_alpha, self.number_document, 'D', consecutive)
        when 4
          self.number_document = codigos + 'D' + digitos #915000D0001
        when 5
          self.number_document = codigos + 'A' + consecutive #915000A0001
          consecutive_alpha(codigos, type_alpha, self.number_document, 'A', consecutive)
        when 6
          self.number_document = codigos + 'I' + consecutive #915000I0001
          consecutive_alpha(codigos, type_alpha, self.number_document, 'I', consecutive)
        when 7
          self.number_document = self.number_document.to_s + '-' + contador.to_s #915000-01 Al momento de generar el RIP quitar el guion (-)
        when 8
          self.number_document = codigos + 'P' + digitos #915000P0001
        when 9
          self.number_document = codigos + 'P' + digitos #915000P0001
        when 10
          self.number_document = self.number_inpec #Número del INPEC
        else
          errors.add(:type_condition, "Inválido")
      end
    end
  end

  #Metodo que permite validar el numero de documento para no repetirse segun el tipo de condicion
  def consecutive_alpha(codigo, alpha, documento, simbolo, consecutivo)
    if alpha.pluck(:number_document).include?(documento) == true
      documento = codigo + simbolo + Array.new(4) { charset.sample }.join
      consecutive_alpha(documento)
    else
      documento = codigo + simbolo + consecutivo
    end
  end

  # Método: Para validar el tipo de documento para los (AS Y MS)
  def validate_condition?
    if self.type_document == Patient::ADULTO_SIN_IDENTIFICAR || self.type_document == Patient::MENOR_SIN_IDENTIFICAR
      if self.type_condition.nil?
        errors.add(:type_condition, "debe seleccionar una opción")
      end
    end
  end

  # Método: Para validar el número de documento diferente a tipo de documento AS y MS) (RIPS)
  def validate_number_document?
    if (self.type_document != Patient::ADULTO_SIN_IDENTIFICAR && self.type_document != Patient::MENOR_SIN_IDENTIFICAR)  
      if self.number_document.empty?
        errors.add(:number_document, "no puede estar vacío")
      elsif self.type_document == Patient::CÉDULA_CIUDADANÍA && (self.number_document.length < 5 || self.number_document.length > 10)
        errors.add(:number_document, "no puede ser menor a 5 ni mayor a 10 caracteres")
      elsif self.type_document == Patient::CÉDULA_EXTRANJERÍA && self.number_document.length > 6
        errors.add(:number_document, "no puede ser mayor a 6 caracteres")
      elsif self.type_document == Patient::CARNÉ_DIPLOMÁTICO && self.number_document.length > 16
        errors.add(:number_document, "no puede ser mayor a 16 caracteres")
      elsif self.type_document == Patient::PASAPORTE && self.number_document.length > 16
        errors.add(:number_document, "no puede ser mayor a 16 caracteres")
      elsif self.type_document == Patient::SALVOCONDUCTO && self.number_document.length > 16
        errors.add(:number_document, "no puede ser mayor a 16 caracteres")
      elsif self.type_document == Patient::PERMISO_ESPECIAL_PERMANENCIA && self.number_document.length > 15
        errors.add(:number_document, "no puede ser mayor a 15 caracteres")
      elsif self.type_document == Patient::RESIDENTE_ESPECIAL_PARA_LA_PAZ && self.number_document.length > 15
        errors.add(:number_document, "no puede ser mayor a 15 caracteres")
      elsif self.type_document == Patient::REGISTRO_CIVIL && self.number_document.length > 11
        errors.add(:number_document, "no puede ser mayor a 11 caracteres")
      elsif self.type_document == Patient::TARJETA_DE_IDENTIDAD && (self.number_document.length < 5 || self.number_document.length > 11)
        errors.add(:number_document, "no puede ser menor a 5 ni mayor a 11 caracteres")
      elsif self.type_document == Patient::CERTIFICADO_DE_NACIDO_VIVO && self.number_document.length > 9
        errors.add(:number_document, "no puede ser mayor a 9 caracteres")
      elsif self.type_document == Patient::ADULTO_SIN_IDENTIFICAR && self.number_document.length > 10
        errors.add(:number_document, "no puede ser mayor a 10 caracteres")
      elsif self.type_document == Patient::MENOR_SIN_IDENTIFICAR && self.number_document.length > 12
        errors.add(:number_document, "no puede ser mayor a 12 caracteres")
      end
    end
  end

  # Método: Para validar el número del INPEC si es el caso
  def validate_number_inpec?
    if (self.type_document == Patient::ADULTO_SIN_IDENTIFICAR || self.type_document == Patient::MENOR_SIN_IDENTIFICAR)  
      if self.type_condition == Patient::POBLACION_RECLUSA
        if self.number_inpec.empty?
          errors.add(:number_inpec, "no puede estar vacío")
        elsif self.number_inpec.length < 6 || self.number_inpec.length > 6
          errors.add(:number_inpec, "debe ser de 6 caracteres")
        end
      end
    end
  end

  # Método: Para permitir que se guarde desde la web
  def create_patient_web?
    self.commit == "web"
  end

  #Método: Permite validar si el documento (CC o TI) son solo numéricos (RIPS)
  def validate_type_document?   
    self.type_document == Patient::CÉDULA_CIUDADANÍA || self.type_document == Patient::TARJETA_DE_IDENTIDAD 
  end

  #Método: Permite validar el tipo de documento dependiendo de la unidad de medida (RIPS)
  def validate_unit_measure_age?
    if self.patient_informations[0].unit_measure_age == PatientInformation::DÍAS && (self.type_document != Patient::REGISTRO_CIVIL && self.type_document != Patient::CERTIFICADO_DE_NACIDO_VIVO && self.type_document != Patient::MENOR_SIN_IDENTIFICAR)
      errors.add(:type_document, "la unidad de medida en días no le corresponde el tipo de documento.")
    elsif self.patient_informations[0].unit_measure_age == PatientInformation::MESES && (self.type_document == Patient::CÉDULA_CIUDADANÍA || self.type_document == Patient::TARJETA_DE_IDENTIDAD || self.type_document == Patient::ADULTO_SIN_IDENTIFICAR)
      errors.add(:type_document, "la unidad de medida en meses no le corresponde el tipo de documento.")
    end
  end

  #Método: Permite validar el tipo de documento dependiendo de la unidad de medida y la edad (RIPS)
  def validate_age?
    if self.patient_informations[0].unit_measure_age == PatientInformation::AÑOS && self.patient_informations[0].age >= 19 && (self.type_document == Patient::REGISTRO_CIVIL || self.type_document == Patient::CERTIFICADO_DE_NACIDO_VIVO || self.type_document == Patient::MENOR_SIN_IDENTIFICAR || self.type_document == Patient::TARJETA_DE_IDENTIDAD)
      errors.add(:type_document, "la edad #{self.patient_informations[0].age} años no corresponde al tipo de documento.")
    elsif self.type_document == Patient::ADULTO_SIN_IDENTIFICAR && self.patient_informations[0].unit_measure_age == PatientInformation::AÑOS && self.patient_informations[0].age <= 17
      errors.add(:type_document, "la edad debe ser mayor a #{self.patient_informations[0].age} años.")
    end
  end

  #Método para validar la unidad de medida dependiendo de lo que se escoja para medir rangos (RIPS)
  def validate_age_size?
    if self.patient_informations[0].unit_measure_age == PatientInformation::AÑOS
      if self.patient_informations[0].age < 1 || self.patient_informations[0].age > 120
        errors.add(:age, "#{self.patient_informations[0].age} no está entre 1 a 120 años")
      end   
    elsif self.patient_informations[0].unit_measure_age == PatientInformation::MESES
      if self.patient_informations[0].age < 1 || self.patient_informations[0].age > 11
        errors.add(:age, "#{self.patient_informations[0].age} no está entre 1 a 11 meses")
      end
    elsif self.patient_informations[0].unit_measure_age == PatientInformation::DÍAS
      if self.patient_informations[0].age < 1 || self.patient_informations[0].age > 29
        errors.add(:age, "#{self.patient_informations[0].age} no está entre 1 a 29 días")
      end
    end
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
        'SC'
      when 5
        'PE'
      when 6
        'RE'
      when 7
        'RC'
      when 8
        'TI'
      when 9
        'CN'  
      when 10
        'AS'
      when 11
        'MS'
    end
  end

  #Permite convertir la información a un csv para la generacion de (US - RIPS)
  def self.to_csv
    CSV.generate do |csv|
      all.each do |paciente|
        pa = paciente.attributes
        pi = paciente.patient_informations.last.attributes
        code_department = Municipality.find(pi['municipality_id']).code_department
        if code_department == 5
          '05'
        elsif code_department == 8
          '08'
        else
          code_department
        end
        rip_us = {a: Patient.name_document(pa['type_document']), b: pa['number_document'], 
             c: Insurance.find(pi['insurance_id']).code, d: pi['type_user'], e: pa['last_name'].upcase, 
             f: pa['second_surname'].blank? ? nil : pa['second_surname'].upcase, g: pa['name'].upcase, h: pa['second_name'].blank? ? nil : pa['second_name'].upcase, i: pi['age'], j: pi['unit_measure_age'],
             k: pa['genre'] == Patient::MASCULINO ? 'M' : 'F', l: code_department,
             m: Municipality.find(pi['municipality_id']).code.to_s.split(code_department.to_s)[1], 
             n: pi['urban_zone'] == PatientInformation::URBANA ? 'U' : 'R'}
        csv << rip_us.values
      end
    end
  end

  #Informacion RIPS de paciente
  def self.patient_rips(client, aseguradora, init_date, end_date)
    includes(:patient_informations, :client).where("clients.id = ? AND patient_informations.insurance_id = ? AND (patients.created_at >= ? AND patients.created_at <= ?)", client, aseguradora, init_date - 1.day, end_date + 1.day).references(:patient_informations, :client)
  end

  #Permite buscar un paciente por nombre o número de documento (IPS)
  def self.patient_search(word, client_id)
    #where("(unaccent(LOWER(name)) ILIKE('%#{word.parameterize.underscore.humanize.downcase}%') OR unaccent(LOWER(second_name)) ILIKE('%#{word.parameterize.underscore.humanize.downcase}%') OR number_document = ?) AND client_id = ?", word, client_id)
    where("((name || ' ' || second_name || ' ' || last_name || ' ' || second_surname) ILIKE ? OR (name || ' ' || last_name || ' ' || second_surname) ILIKE ? OR number_document = ?) AND client_id = ?", "%#{word.parameterize.underscore.humanize.downcase}%", "%#{word.parameterize.underscore.humanize.downcase}%", word, client_id)
  end

  def self.consult(number_document)
    includes(consultations: :doctor).where("consultations.archived = ? AND users.number_document = ?", true, number_document).order(created_at: :desc).references(consultations: :doctor)
  end

  def self.control(estado, number_document)
    includes(consultations: :doctor).where("consultations.status IN (?) AND consultations.archived = ? AND users.number_document = ?", estado, false, number_document).order(created_at: :desc).references(consultations: :doctor)
  end
end
