#Este pertenece al Lista pendientes un WS
object @patient_consults

#attributes :id, :patient_id, :doctor_id, :status, :created_at

#Permite traer la ultima informacion del paciente
node :patient do |patient|
  patient.nil? ? Patient.new.as_json : partial("api/v1/patients/show_patient_consult", object: patient)
end