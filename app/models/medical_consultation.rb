class MedicalConsultation < ApplicationRecord
  belongs_to :consultation, optional: true


  validates :evolution_injuries, :evolution_time, :unit_measurement, :symptom, :change_symptom, :reason_consultation, :current_illness, presence: true, on: :create 
  validates :evolution_time, length: { in: 1..5 }, on: :create
  validate :validate_obvious_changes?, on: :create
  validate :validate_exams?, on: :create

  #mount_base64_uploader :physical_audio, PhysicalAudioConsultantUploader


  #Number_injuries (Número de lesiones)
  MENOS_DE_CINCO = 1
  CINCO_A_DIEZ = 2
  MAS_DE_DIEZ = 3

  #Evolution_injuries (Evolución de lesiones)
  ESTABLE = 1
  AUMENTO_TAMAÑO = 2
  CAMBIO_COLOR = 3
  AUMENTO_NUMERO = 4
  PERMANENTES = 5
  PROGRESIVAS = 6
  RECURRENTES = 7

  #Unit_measurement (Unidad de medida)
  AÑOS = 1
  MESES = 2
  DIAS = 3

  #Symptom (Síntomas)
  PRURITO = 1
  ARDOR = 2
  DOLOR = 3
  NINGUNA = 4

  #change symptom (Cambio de sintomas)
  SI_EMPEORAN_DIA = 1
  SI_EMPEORAN_NOCHE = 2
  NO = 3

  #Valida que el audio fisico o la descripcion debe ser obligatorio
  def validate_exams?
    if self.description_physical_examination.blank? && self.physical_audio.blank?
      errors.add(:exam, "audio físico o descripción no puede estar vacío")
    end 
  end

  #Valida los campos (blood, exude, suppurate)
  def validate_obvious_changes?
    if self.blood.nil? 
      errors.add(:blood, "no puede ser vacío")
    elsif self.exude.nil?
      errors.add(:exude, "no puede ser vacío")
    elsif self.suppurate.nil?
      errors.add(:suppurate, "no puede ser vacío")    
    end
  end

  #Todas las consultas del cliente de los pacientes por aseguradora
  def self.consult_medical(client, aseguradora, estados)
    includes({consultation: [patient: :patient_informations]}).where("patients.client_id = ? AND patient_informations.insurance_id = ? AND consultations.status IN (?)", client, aseguradora, estados).references(:consultation, {patient: :patient_informations})
  end

  #Permite convertir la información a un csv para la generacion de (AC - RIPS)
  def self.to_csv(consultas, ips_insurance)
    factura = BillsInsurance.find_by(ips_insurance: ips_insurance)
    CSV.generate do |csv|
      consultas.each do |medical|
        mc = medical.attributes
        pa = medical.consultation.patient.attributes
        pi = medical.consultation.patient_information.attributes
        if medical.class.name == "MedicalConsultation" && medical.consultation.status == Consultation::RESUELTO
          spe = medical.consultation.specialist_responses.first
          diag = spe.other_diagnostics.first.blank? ? nil : Disease.find(spe.other_diagnostics.first.disease_id).code
          diag2 = spe.other_diagnostics.second.blank? ? nil : Disease.find(spe.other_diagnostics.second.disease_id).code
          diag3 = spe.other_diagnostics.third.blank? ? nil : Disease.find(spe.other_diagnostics.third.disease_id).code
          diag4 = spe.other_diagnostics.fourth.blank? ? nil : Disease.find(spe.other_diagnostics.fourth.disease_id).code
          type_diag = spe.other_diagnostics.blank? ? nil : spe.other_diagnostics.first.type_diagnostic
        elsif medical.class.name == "MedicalControl" && medical.consultation_control.status == Consultation::RESUELTO
          spe = medical.consultation_control.specialist_responses.first
          diag = spe.other_diagnostics.first.blank? ? nil : Disease.find(spe.other_diagnostics.first.disease_id).code
          diag2 = spe.other_diagnostics.second.blank? ? nil : Disease.find(spe.other_diagnostics.second.disease_id).code
          diag3 = spe.other_diagnostics.third.blank? ? nil : Disease.find(spe.other_diagnostics.third.disease_id).code
          diag4 = spe.other_diagnostics.fourth.blank? ? nil : Disease.find(spe.other_diagnostics.fourth.disease_id).code
          type_diag = spe.other_diagnostics.blank? ? nil : spe.other_diagnostics.first.type_diagnostic
        elsif medical.class.name == "MedicalConsultation"
          diag, diag2, diag3, diag4, type_diag = medical.consultation.diagnostic_impression, nil, nil, nil, 1
        else
          diag, diag2, diag3, diag4, type_diag = medical.consultation_control.diagnostic_impression, nil, nil, nil, 1
        end
        rip_ac = {a: factura.nil? ? nil : factura.bill_number, b: Client.find(pa['client_id']).code_service_provider, 
                  c: Patient.name_document(pa['type_document']), d: pa['number_document'],
                  e: mc['created_at'].strftime("%d/%m/%Y"), f: pi['authorization_number'].blank? ? nil : pi['authorization_number'],
                  g: pi['code_consultation'].gsub(".",""), h: MedicalConsultation.finalidad_consulta(pi['purpose_consultation']),
                  i: MedicalConsultation.causa_externa(pi['external_cause']), j: diag, k: diag2, l: diag3, m: diag4, n: type_diag,
                  o: factura.nil? ? 0 : factura.value_consultation, p: factura.nil? ? 0 : factura.value_moderator_fee, q: factura.nil? ? 0 : factura.net_to_pay_contract_entity}
        csv << rip_ac.values
      end
    end
  end

  #Ordenamiento segun RIPS
  def self.finalidad_consulta(purpose)
    case purpose
      when 1
        '10'
      when 2
        '01'
      when 3
        '02'
      when 4
        '03'
      when 5
        '04'
      when 6
        '05'
      when 7
        '06'
      when 8
        '07'
      when 9
        '08'  
      when 10
        '09'
    end
  end

  #Ordenamiento segun RIPS
  def self.causa_externa(purpose)
    case purpose
      when 1
        '13'
      when 2
        '01'
      when 3
        '02'
      when 4
        '03'
      when 5
        '04'
      when 6
        '05'
      when 7
        '06'
      when 8
        '07'
      when 9
        '08'  
      when 10
        '09'
      when 11
        '10'
      when 12
        '11'
      when 13
        '12'
      when 14
        '14'
      when 15
        '15'
    end
  end

  # DEL 1 AL 8 EN FINALIDAD DE CONSULTA EL DIAGNOSTICO EMPIEZA CON Z

  #Permite convertir la información a un csv para la generacion de (AP - RIPS)
  #NO APLICA PERO ESTA HECHO
  def self.to_csv_ap(client_id)
    cliente = Client.find(client_id)
    CSV.generate do |csv|
      all.each do |procedimiento|
        mc = procedimiento.attributes
        pa = procedimiento.consultation.patient.attributes
        pi = procedimiento.consultation.patient_information.attributes
        spe = procedimiento.consultation.specialist_responses.first
        rip_ap = {a: cliente.bills_insurances.last.bill_number, b: cliente.code_service_provider, 
                  c: Patient.name_document(pa['type_document']), d: pa['number_document'],
                  e: mc['created_at'].strftime("%d/%m/%Y"), f: pi['authorization_number'],
                  g: nil, h: 1, i: 1, j: nil, k: spe.other_diagnostics.blank? ? nil : Disease.find(spe.other_diagnostics.second.disease_id).code,
                  l: spe.other_diagnostics.blank? ? nil : Disease.find(spe.other_diagnostics.first.disease_id).code,
                  m: nil, n: nil, o: 0}
        csv << rip_ap.values
      end
    end
  end
end
