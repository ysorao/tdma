#Lista toda la informacion del especialista al responder una consulta (web)
object @specialist_info

attributes :case_analysis, :analysis_description, :consultation_id, :consultation_control_id

node :date do |specialist|
  if specialist.consultation_id.nil?
    specialist.consultation_control.status == Consultation::EVALUANDO ? nil : specialist.created_at.strftime("%d/%m/%Y")
  else
    specialist.consultation.status == Consultation::EVALUANDO ? nil : specialist.created_at.strftime("%d/%m/%Y")
  end
end

node :hour do |specialist|
  if specialist.consultation_id.nil?
    specialist.consultation_control.status == Consultation::EVALUANDO ? nil : specialist.created_at.strftime("%I:%M %p")
  else
    specialist.consultation.status == Consultation::EVALUANDO ? nil : specialist.created_at.strftime("%I:%M %p")
  end
end

#Estado de la consulta o el control (remitido requerimiento)
node :status do |specialist|
  if specialist.consultation_id.nil?
    if specialist.consultation_control.status == Consultation::REMISION
      'Remitida'
    elsif specialist.consultation_control.status == Consultation::REQUERIMIENTO
      'Requerimiento'
    elsif specialist.consultation_control.status == Consultation::RESUELTO
      'Resuelto'
    elsif specialist.consultation_control.status == Consultation::EVALUANDO && specialist.consultation_control.requests.count > 0 
      'Requerimiento'
    else
      'Evaluando'
    end
  else
    if specialist.consultation.status == Consultation::REMISION && specialist.consultation.consultation_controls.blank?
      'Remitida'
    elsif specialist.consultation.status == Consultation::REMISION && !specialist.consultation.consultation_controls.detect{|w| w.status == Consultation::REMISION}.nil?
      'Resuelto'
    elsif specialist.consultation.status == Consultation::REQUERIMIENTO && specialist.consultation.consultation_controls.blank?
      'Requerimiento'
    elsif specialist.consultation.status == Consultation::REQUERIMIENTO && !specialist.consultation.consultation_controls.detect{|w| (w.status == Consultation::RESUELTO || w.status == Consultation::EVALUANDO)}.nil?
      'Resuelto'
    elsif specialist.consultation.status == Consultation::RESUELTO
      'Resuelto'
    elsif specialist.consultation.status == Consultation::EVALUANDO
      'Evaluando'
    end 
  end  
end

#Información basica del especialista
node :specialist do |especialista|
  especialista.nil? ? '' : partial("api/v1/users/show_web", object: especialista.response)
end

#Información de otros diagnosticos
node :diagnostics do |specialist|
  specialist.other_diagnostics.blank? ? [] : partial("api/v1/diagnostics/show_web", object: specialist.other_diagnostics.order(:id))
end

#Informacion del tratamiento recibido en la consulta
node :treatment do |specialist|
	if specialist.consultation_id.nil?
		specialist.consultation_control.recommended_treatment.nil? ? 'Ninguno' : specialist.consultation_control.recommended_treatment
  else
    specialist.consultation.recommended_treatment.nil? ? 'Ninguno' : specialist.consultation.recommended_treatment  
  end
end

#Mostrar solicitud de examenes
node :request_exams do |specialist|
  specialist.request_exams.blank? ? [] : partial("api/v1/request_exams/show_web", object: specialist.request_exams)
end

#Informacion de las formulaciones
node :formulas do |specialist|
  specialist.formulas.blank? ? [] : partial("api/v1/formulas/show_web", object: specialist.formulas)
end

#Informacion de los mipres por consulta
node :mipres do |specialist|
  specialist.mipres_files.blank? ? [] : partial("api/v1/mipres_files/show_web", object: specialist.mipres_files)
end

#Informacion del próximo control
node :specialist_response do |specialist|
  specialist.control_recommended.nil? ? 'Ninguno' : specialist.control_recommended
end

#Informacion del requerimiento
node :request do |specialist|
	if specialist.consultation_id.nil?
    specialist.consultation_control.requests.blank? ? '' : partial("api/v1/request/show_web", object: specialist.consultation_control.requests)    
  else
    specialist.consultation.requests.blank? ? '' : partial("api/v1/request/show_web", object: specialist.consultation.requests)
  end
end

node :control do |specialist|
  specialist.consultation_control_id.nil? ? 'Sin control' : "Control - #{specialist.consultation_control.medical_control.created_at.strftime("%d/%m/%Y")}"  
end

#Informacion de la remisión
node :remission do |specialist|
  if specialist.consultation_id.nil?
    specialist.consultation_control.status == Consultation::REMISION ? {type_remission: Consultation.remission_consult(specialist.consultation_control.type_remission), remission_comments: specialist.consultation_control.remission_comments} : ''
  else
    specialist.consultation.status == Consultation::REMISION ? {type_remission: Consultation.remission_consult(specialist.consultation.type_remission), remission_comments: specialist.consultation.remission_comments} : ''
  end
end 