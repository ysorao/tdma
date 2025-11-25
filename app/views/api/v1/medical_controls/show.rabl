object @medical_controls

attributes :id, :doctor_id, :consultation_id, :consultation_control_id, :subjetive_improvement, :did_treatment, :audio_clinic, :clinic_description, :audio_annex, :annex_description, :annex_photo

node :created_at do |control|
  control.created_at.strftime("%d/%m/%Y %I:%M %p")
end

node :status do |control|
  control.status == 0 ? 'Inactivo' : 'Activo'
end

node :name_complete do |control|
  control.control_doctor.name.to_s + ' ' + control.control_doctor.surnames.to_s
end

node :tolerated_medications do |control|
  if control.tolerated_medications == 1
  	'Sí'
  elsif control.tolerated_medications == 2
    'No'
  else
    'No se formularon'
  end
end

node :bandera do |info|
  if @flag == true
    'no'
  end
end

#Permite traer la informacion de la consulta del control
node :consultation_control do |control|
  partial("api/v1/consultation_controls/show_last", object: control.consultation_control)
end

node :images_control do |info|
  info.consultation_control.annex_images.blank? ? [] : partial("api/v1/annex_images/index", object: info.consultation_control.annex_images) 
end