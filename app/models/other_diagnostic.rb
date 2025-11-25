class OtherDiagnostic < ApplicationRecord
  belongs_to :specialist_response, optional: true
  belongs_to :disease, optional: true

  validates :type_diagnostic, :specialist_response_id, presence: true
  validate :validate_disease?

  #CONSTANTES

  #type_diagnostic
  IMPRESIÓN_DIAGNOSTICA = 1
  CONFIRMADO_NUEVO = 2
  CONFIRMADO_REPETIDO = 3

  #status
  INACTIVO = 0
  ACTIVO = 1

  def validate_disease?
    if self.disease_id.nil?
      errors.add(:disease_id, "Es un autocompletar por lo tanto debe escoger una opción de la lista.")      
    end
  end

  #Permite filtrar los diagnosticos de las consultas en estado resuelto y agruparlos por CIE10
  def self.order_diagnostics
    #consultas = OtherDiagnostic.includes(specialist_response: :consultation).where("specialist_responses.consultation_id IS NOT NULL").references(specialist_response: :consultation)
    #controles = OtherDiagnostic.includes(specialist_response: :consultation_control).where("specialist_responses.consultation_control_id IS NOT NULL").references(specialist_response: :consultation_control)
    cons = SpecialistResponse.order(:created_at).where("consultation_id IS NOT NULL").pluck(:id)
    cont = SpecialistResponse.order(:created_at).where("consultation_control_id IS NOT NULL").pluck(:id)
    consultas = OtherDiagnostic.where("specialist_response_id IN (?)", cons).order(:created_at).uniq(&:specialist_response_id)
    controles = OtherDiagnostic.where("specialist_response_id IN (?)", cont).order(:created_at).uniq(&:specialist_response_id)
    teleconsultas = (consultas + controles).group_by(&:disease_id)
  end

  #Permite filtrar los diagnosticos de las consultas en estado resuelto y agruparlos por CIE10 por medio de filtros
  def self.filter_diagnostics(municipio, edad, rango, genero, zona_urbana, tipo_usuario, especialista)
    if (rango == (nil..nil) || rango == (""..""))
      rango = (1..101).step(1).to_a
    else
      rango
    end

    consultas = OtherDiagnostic.includes({specialist_response: {consultation: {patient_information: :patient}}}).where("specialist_responses.consultation_id IS NOT NULL AND specialist_responses.specialist_id IN (?) AND consultations.specialist_id IN (?) AND patient_informations.municipality_id IN (?) AND patient_informations.age IN (?) AND patient_informations.age IN (?) AND patients.genre IN (?) AND patient_informations.urban_zone IN (?) AND patient_informations.type_user IN (?)", especialista.nil? ? User.where(type_professional: 4).pluck(:id) : especialista, especialista.nil? ? User.where(type_professional: 4).pluck(:id) : especialista, municipio == "" ? (1..1123).step(1).to_a : municipio, edad == "" ? (1..101).step(1).to_a : edad, rango, genero == "" ? [1,2] : genero, zona_urbana == "" ? [1,2] : zona_urbana, tipo_usuario == "" ? (1..9).step(1).to_a : tipo_usuario).references({specialist_response: {consultation: {patient_information: :patient}}}).uniq(&:specialist_response_id)
    controles = OtherDiagnostic.includes({specialist_response: {consultation_control: {patient: :patient_informations}}}).where("specialist_responses.consultation_control_id IS NOT NULL AND specialist_responses.specialist_id IN (?) AND consultation_controls.specialist_id IN (?) AND patient_informations.municipality_id IN (?) AND patient_informations.age IN (?) AND patient_informations.age IN (?) AND patients.genre IN (?) AND patient_informations.urban_zone IN (?) AND patient_informations.type_user IN (?)", especialista.nil? ? User.where(type_professional: 4).pluck(:id) : especialista, especialista.nil? ? User.where(type_professional: 4).pluck(:id) : especialista, municipio == "" ? (1..1123).step(1).to_a : municipio, edad == "" ? (1..101).step(1).to_a : edad, rango, genero == "" ? [1,2] : genero, zona_urbana == "" ? [1,2] : zona_urbana, tipo_usuario == "" ? (1..9).step(1).to_a : tipo_usuario).references({specialist_response: {consultation_control: {patient: :patient_informations}}}).uniq(&:specialist_response_id)
    teleconsultas = (consultas + controles).group_by(&:disease_id)
  end
end
