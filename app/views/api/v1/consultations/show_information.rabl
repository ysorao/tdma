#Webservice que lista la informacion completa de una consulta o control individual
object @patient_information

#Permite traer la ultima informacion del paciente
node :patient do |patient|
  patient.nil? ? Patient.new.as_json : partial("api/v1/patients/show_patient_consult", object: patient)
end