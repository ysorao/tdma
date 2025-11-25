#Información del requerimiento (WEB)
object @request

attributes :id, :comment, :status, :audio_request, :description_request, :specialist_id, :reason, :other_reason, :consultation_id, :consultation_control_id, :doctor_id, :nurse_id

node :medical_control_id do |request|
  request.consultation_control_id.nil? ? nil : request.consultation_control_id
end

node :type_request do |request|
  if request.specialist_request.type_specialist == User::DERMATOLOGO
	  if request.type_request == 1 
      'No fue posible responder la teleconsulta: Imágenes desenfocadas e insuficientes para el diagnóstico. Por favor repetirlas.'
    elsif request.type_request == 2
      'No fue posible responder la teleconsulta: No hay imágenes con acercamiento de la lesión. Por favor adicionar imágenes con zoom.'
    elsif request.type_request == 3
      'No fue posible responder la teleconsulta: Se requieren imágenes perpendiculares de la lesión. Por favor adicionarlas.'
    elsif request.type_request == 4
      'No fue posible responder la teleconsulta: Examen físico incompleto. Por favor describir mejor el tipo de lesión, distribucción y localización.'
    else
      'Otro'
    end
	else
    if request.type_request == 1 
	  	'No fue posible responder la teleconsulta de enfermería: Imágenes desenfocadas e insuficientes para el diagnóstico. Por favor repetirlas.'
	  elsif request.type_request == 2
	    'No fue posible responder la teleconsulta de enfermería: No hay imágenes con acercamiento de la lesión. Por favor adicionar imágenes con detalles de la lesión a 2x, 4x o 6x. Por favor adicionarlas.'
	  elsif request.type_request == 3
	    'No fue posible responder la teleconsulta de enfermería: Se requiere imágenes perpendiculares de la lesión. Por favor adicionarlas.'
	  elsif request.type_request == 4
	  	'No fue posible responder la teleconsulta de enfermería. Examen físico incompleto. Por favor describir mejor y enviar para evaluación.'
	  else
      'Otro'
    end
	end
end

node :reason_result do |request|
  if request.reason == 1 
  	'El paciente no regreso'
  elsif request.reason == 2
    'El paciente esta sano'
  else
  	'No fue posible resolver la solicitud'
  end
end

node :doctor do |request|
  request.doctor_id.nil? ? {} : partial("api/v1/users/show_web", object: request.doctor_request)
end

#node :nurse do |request|
  #request.nurse_id.nil? ? {} : partial("api/v1/users/show_web", object: request.nurse_request) 
#end

node :specialist do |request|
  request.specialist_id.nil? ? {} : partial("api/v1/users/show_web", object: request.specialist_request)	
end

node :created_at do |request|
  request.created_at.strftime("%d/%m/%Y %I:%M %p")
end

node :updated_at do |request|
  request.updated_at.strftime("%d/%m/%Y %I:%M %p")
end

node :date do |request|
  request.created_at.strftime("%d/%m/%Y")
end

node :hour do |request|
  request.created_at.strftime("%I:%M %P")
end