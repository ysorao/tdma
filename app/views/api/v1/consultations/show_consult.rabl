object @info_consultations

attributes :id, :status, :type_profesional, :annex_description, :audio_annex, :date_archived, :patient_id, :patient_information_id, :assistant_id, :type_remission, :remission_comments, :doctor_id, :nurse_id

node :diagnostic_impression do |consult|
  disease = Disease.find_by(code: consult.diagnostic_impression)
  disease.nil? ? consult.diagnostic_impression : disease.name
end
node :diagnostic_impression_code do |consult|
  disease = Disease.find_by(code: consult.diagnostic_impression)
  disease.nil? ? '' : disease.code
end

node :annex_description do |info|
  info.annex_description.nil? || info.annex_description.blank? ? 'Ninguno' : info.annex_description
end

node :created_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %I:%M %p")
end

node :updated_at do |consult|
  consult.updated_at.strftime("%d/%m/%Y %I:%M %p")
end

node :doctor do |consult|
  consult.doctor.nil? ? {} : partial("api/v1/users/show_web", object: consult.doctor)
end

#node :nurse do |consult|
  #consult.nurse.nil? ? {} : partial("api/v1/users/show_web", object: consult.nurse) 
#end

node :type_remission do |consult|
  if consult.type_remission == 1
    'Cuadro clínico complejo para evaluar por teledermatología. Favor remitir el paciente a dermatólogo presencial.'
  elsif consult.type_remission == 2
    'Se requiere valoración por otra especialidad diferente a dermatología. Favor remitir el paciente a la especialidad correspondiente.'
  elsif consult.type_remission == 3
    'Otro'
  end
end

#elsif consult.status == 4
    #'Archivado'
  #elsif consult.status == 5
    #'Proceso'
  #elsif consult.status == 6
    #'Sin creditos'

node :count_controls do |consult|
  consult.consultation_controls.count
end

#Permite traer la ultima informacion del paciente
node :patient_information do |consult|
  consult.nil? ? PatientInformation.new.as_json : partial("api/v1/patients/information", object: consult.patient_information)
end

#Información de las consultas del médico
node :medical_consultation do |consult|
  #consult.nil? ? [] : consult.medical_consultations.map { |control| partial("api/v1/medical_consultations/show", object: control)}
  consult.nil? ? '' : partial("api/v1/medical_consultations/show", object: consult.medical_consultation)
end

#Información de las consultas de le enfermera
#node :nurse_consultation do |consult|
  #consult.nil? ? [] : consult.nurse_consultations.map { |control| partial("api/v1/nurse_consultations/show", object: control)}
  #consult.nil? ? '' : partial("api/v1/nurse_consultations/show", object: consult.nurse_consultation)
#end

#Información de los controles de las consultas
node :consultation_controls do |consult|
  consult.nil? ? [] : consult.consultation_controls.map { |control| partial("api/v1/consultation_controls/show", object: control)}
end

node :injuries do |consult|
  consult.nil? ? [] : consult.injuries.order(created_at: :desc).map { |injury| partial("api/v1/injuries/show_injury_images", object: injury)  }
end

#Informacion del tratamiento recibido en la consulta
node :treatment do |consult|
  consult.recommended_treatment
end

#Informacion del próximo control
node :specialist_response do |consult|
  consult.specialist_responses.blank? ? [] : partial("api/v1/specialist_response/show_web", object: consult.specialist_responses)
end

#Informacion del requerimiento
node :request do |consult|
  partial("api/v1/request/show_web", object: consult.requests)
end

child :annex_images do
  attributes :id, :annex_url, :consultation_id

  node :annex_url do |image|
    #dynamic_images(image, 1, nil)
    "https://#{request.host}:#{request.port}" + '' + image.annex_url.url
  end
end


