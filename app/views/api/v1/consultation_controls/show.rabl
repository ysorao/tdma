object @consultation_control

attributes :id, :status, :type_professional, :consultation_id, :diagnostic_impression, :remission_comments, :doctor_id, :nurse_id

node :created_at do |consult_control|
  consult_control.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :doctor do |consult_control|
  consult_control.doctor_control.nil? ? {} : partial("api/v1/users/show_web", object: consult_control.doctor_control)
end

#node :nurse do |consult_control|
  #consult_control.nurse_control.nil? ? {} : partial("api/v1/users/show_web", object: consult_control.nurse_control) 
#end

node :type_remission do |consult_control|
  if !consult_control.doctor_id.nil?
    if consult_control.type_remission == 1
      'Cuadro clínico complejo para evaluar por teledermatología. Favor remitir el paciente a dermatólogo presencial.'
    elsif consult_control.type_remission == 2
      'Se requiere valoración por otra especialidad diferente a dermatología. Favor remitir el paciente a la especialidad correspondiente.'
    elsif consult_control.type_remission == 3
      'Otro'
    end
  else
    Consultation.nurse_remission_consult(consult_control.type_remission)
  end
end

node :medical_control do |consult_control|
  #consult_control.nil? ? [] : consult_control.medical_controls.map { |control| partial("api/v1/medical_controls/index", object: control)}
  consult_control.nil? ? '' : partial("api/v1/medical_controls/index", object: consult_control.medical_control)
end

#node :nurse_control do |consult_control|
  #consult_control.nil? ? [] : consult_control.nurse_controls.map { |control| partial("api/v1/nurse_controls/index", object: control)}
  #consult_control.nil? ? '' : partial("api/v1/nurse_controls/index", object: consult_control.nurse_control)
#end

node :injuries do |consult_control|
  consult_control.nil? ? [] : consult_control.injuries.map { |control| partial("api/v1/injuries/show_injury_images", object: control)}
end

#Informacion del tratamiento recibido en la consulta
node :treatment do |consult_control|
  consult_control.recommended_treatment
end

#Informacion del próximo control
node :specialist_response do |consult_control|
  consult_control.specialist_responses.blank? ? [] : partial("api/v1/specialist_response/show_web", object: consult_control.specialist_responses)
end

#Informacion del requerimiento
node :request do |consult_control|
  partial("api/v1/request/show_web", object: consult_control.requests)
end

child :annex_images do
  attributes :id, :annex_url, :consultation_control_id

  node :annex_url do |image|
    #dynamic_images(image, 1, nil)
    "https://#{request.host}:#{request.port}" + '' + image.annex_url.url
  end
end
