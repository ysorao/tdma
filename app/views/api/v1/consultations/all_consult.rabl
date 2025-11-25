object @consults

  attributes :id, :status, :patient_id, :patient_information_id, :specialist_id, :doctor_id, :type_profesional

  node :diagnostic_impression do |consult|
	  disease = Disease.find_by(code: consult.diagnostic_impression)
	  disease.nil? ? consult.diagnostic_impression : disease.name
	end
                  
  node :created_at do |consult|
    consult.created_at.strftime("%d/%m/%Y %HH:%MM")
  end

  node :count_controls do |consult|
    consult.consultation_controls.count
  end

  #Información de las consultas del médico
  node :medical_consultation do |consult|
    consult.nil? ? '' : partial("api/v1/medical_consultations/show", object: consult.medical_consultation)
  end

  node :consultation_controls do
    []
  end

  #Permite traer la ultima informacion del paciente
  node :patient_information do |consult|
    consult.nil? ? PatientInformation.new.as_json : partial("api/v1/patients/information", object: consult.patient_information)
  end