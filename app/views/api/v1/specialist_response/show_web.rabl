#Información del próximo control (WEB)
object @response

attributes :id, :control_recommended, :case_analysis, :analysis_description, :consultation_control_id, :consultation_id, :specialist_id

node :created_at do |response|
  if response.consultation_id.nil?
    response.consultation_control.status == Consultation::EVALUANDO ? nil : response.created_at.strftime("%d/%m/%Y")
  else
    response.consultation.status == Consultation::EVALUANDO ? nil : response.created_at.strftime("%d/%m/%Y")
  end
end

node :updated_at do |response|
  if response.consultation_id.nil?
    response.consultation_control.status == Consultation::EVALUANDO ? nil : response.updated_at.strftime("%d/%m/%Y %I:%M %p")
  else
    response.consultation.status == Consultation::EVALUANDO ? nil : response.updated_at.strftime("%d/%m/%Y %I:%M %p")
  end
end

node :hour do |response|
  if response.consultation_id.nil?
    response.consultation_control.status == Consultation::EVALUANDO ? nil : response.created_at.strftime("%I:%M %p")
  else
    response.consultation.status == Consultation::EVALUANDO ? nil : response.created_at.strftime("%I:%M %p")
  end
end

#Información de otros diagnosticos
node :diagnostics do |response|
  response.other_diagnostics.blank? ? [] : partial("api/v1/diagnostics/show_web", object: response.other_diagnostics.order(:id))
end

#Mostrar solicitud de examenes
node :request_exams do |response|
  response.request_exams.blank? ? [] : partial("api/v1/request_exams/show_web", object: response.request_exams)
end

#Informacion de las formulaciones
node :formulas do |response|
  response.formulas.blank? ? [] : partial("api/v1/formulas/show_web", object: response.formulas)
end

#Informacion de los mipres por consulta
node :mipres do |response|
  response.mipres_files.blank? ? [] : partial("api/v1/mipres_files/show_web", object: response.mipres_files)
end

#Información basica del especialista
node :specialist do |response_spec|
  response_spec.response.nil? ? nil : partial("api/v1/users/show_web", object: response_spec.response)
end