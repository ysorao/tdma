#Este pertenece al Buscar un paciente un WS
object @patient

node :patient do |patient|
  patient.nil? ? Patient.new.as_json : {id: patient.id, type_document: patient.type_document, type_condition: patient.type_condition, number_document: patient.number_document, name: patient.name, second_name: patient.second_name, last_name: patient.last_name, second_surname: patient.second_surname, birthdate: patient.birthdate, genre: patient.genre, created_at: patient.created_at.strftime("%d/%m/%Y"), number_inpec: patient.number_inpec}
end

#Permite traer la ultima informacion del paciente
node :patient_information do |patient|
  #patient.nil? ? PatientInformation.new.as_json : patient.patient_informations.last.as_json
  patient.nil? ? PatientInformation.new.as_json : partial("api/v1/patients/information", object: patient.patient_informations.last)
end

#Permite traer las consultas del paciente
node :consultants do |patient|
  #patient.nil? ? [] : patient.consultations.where.not(status: -1).map { |consult| partial("api/v1/consultations/show_patient", object: consult)  }
  patient.nil? ? [] : patient.consultations.where.not(status: -1).map { |consult| partial("api/v1/consultations/show_consult", object: consult)  }
end

