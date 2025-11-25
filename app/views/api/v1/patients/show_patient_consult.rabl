#Este pertenece al Listar pendientes un WS
object @patient

attributes :id, :type_document, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname, :birthdate, :genre, :number_inpec

node :created_at do |patient|
  patient.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :status do |patient|
  patient.patient_informations.last.status
end



#Permite traer la ultima informacion del paciente
#node :patient_information do |patient|
  #patient.nil? ? PatientInformation.new.as_json : patient.patient_informations.last.as_json
  #patient.nil? ? PatientInformation.new.as_json : partial("api/v1/patients/information", object: patient.patient_informations.last)
#end

#Permite traer las consultas del paciente
node :consultants do |patient|
  #patient.nil? ? [] : patient.consultations.as_json
  patient.nil? ? [] : patient.consultations.order(updated_at: :desc).map { |consult| partial("api/v1/consultations/show_consult", object: consult)  }
end