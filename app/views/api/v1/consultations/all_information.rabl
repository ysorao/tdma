#Este pertenece a la Lista nueva de pendientes un WS
object @patient

#Permite traer la ultima informacion del paciente
node :patient do |patient|
  patient.nil? ? Patient.new.as_json : partial("api/v1/patients/index_information", object: patient)
end
