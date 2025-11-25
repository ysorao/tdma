#Lista toda la informacion del especialista al responder una consulta (web)
object @nurse_specialist_info

attributes :case_analysis, :analysis_description

node :date do |specialist|
  specialist.created_at.strftime("%d/%m/%Y")
end

node :hour do |specialist|
  specialist.created_at.strftime("%I:%m %P")
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
    end
  else
    if specialist.consultation.status == Consultation::REMISION && specialist.consultation.consultation_controls.blank?
      'Remitida'
    elsif specialist.consultation.status == Consultation::REMISION && !specialist.consultation.consultation_controls.detect{|w| w.status == Consultation::REMISION}.nil?
      'Resuelto'
    elsif specialist.consultation.status == Consultation::REQUERIMIENTO && specialist.consultation.consultation_controls.blank?
      'Requerimiento'
    elsif specialist.consultation.status == Consultation::REQUERIMIENTO && !specialist.consultation.consultation_controls.detect{|w| w.status == Consultation::REQUERIMIENTO}.nil?
      'Resuelto'
    elsif specialist.consultation.status == Consultation::RESUELTO
      'Resuelto'
    end 
  end  
end

node :control_recommended do |specialist|
  specialist.control_recommended.nil? ? 'Ninguno' : specialist.control_recommended  
end

#Información basica del especialista
node :specialist do |especialista|
  especialista.nil? ? nil : partial("api/v1/users/show_web", object: especialista.response)
end

#Informacion del tratamiento recibido en la consulta
node :treatment do |specialist|
  if specialist.consultation_id.nil?
    specialist.consultation_control.recommended_treatment.nil? ? 'Ninguno' : specialist.consultation_control.recommended_treatment
  else
    specialist.consultation.recommended_treatment.nil? ? 'Ninguno' : specialist.consultation.recommended_treatment  
  end
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
  specialist.consultation_control_id.nil? ? 'Sin control' : "Control - #{specialist.consultation_control.nurse_control.created_at.strftime("%d/%m/%Y")}"  
end

#Informacion de la remisión
node :remission do |specialist|
  if specialist.consultation_id.nil?
    specialist.consultation_control.status == Consultation::REMISION ? {type_remission: Consultation.nurse_remission_consult(specialist.consultation_control.type_remission), remission_comments: specialist.consultation_control.remission_comments} : ''
  else
    specialist.consultation.status == Consultation::REMISION ? {type_remission: Consultation.nurse_remission_consult(specialist.consultation.type_remission), remission_comments: specialist.consultation.remission_comments} : ''
  end
end