#Webservice que lista la informacion completa de una consulta o control individual
object @patient

attributes :id, :type_document, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname

node :created_at do |patient|
  patient.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :status do |patient|
  patient.patient_informations.last.status
end

#Permite traer las consultas del paciente
node :consultants do |patient|
  #patient.nil? ? [] : patient.consultations.as_json
  patient.nil? ? [] : patient.consultations.order(updated_at: :desc).map { |consult| partial("api/v1/consultations/individual_consult", object: consult)  }
end