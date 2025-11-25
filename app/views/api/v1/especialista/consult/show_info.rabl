#Lista toda la informacion de paciente y su consulta (web)
object @patient_consult

attributes :id, :date_archived, :patient_id, :patient_information_id, :doctor_id

node :annex_description do |consult|
  consult.annex_description
end

node :audio_annex do |consult|
  consult.audio_annex
end

node :doctor_id do |consult|
  consult.doctor.name.to_s + ' ' + consult.doctor.surnames.to_s
end

node :created_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %I:%M:%S")
end

node :created_web do |consult|
  consult.created_at.strftime("%d/%m/%Y %I:%M %p")
end

node :status do |info|
  if info.status == 1
    'Resuelto'
  elsif info.status == 2
    'Requerimiento'
  elsif info.status == 3
    'Pendiente'
  elsif info.status == 4
    'Archivado'
  elsif info.status == 5
    'Proceso'
  elsif info.status == 6
    'Sin creditos'
  elsif info.status == 7
    'Remisión'
  else
    'Evaluando'
  end
end

#Informacion del requerimiento de consulta
node :request do |consult|
  partial("api/v1/request/show_web", object: consult.requests.order(:id))
end

#Permite traer la informacion de la consulta
node :medical_consult do |consult|
  partial("api/v1/medical_consultations/info_specialist", object: consult.medical_consultation)
end

#Permite traer la informacion de la consulta del control
node :medical_control do |consult|
  partial("api/v1/medical_controls/show", object: consult.medical_controls.blank? ? [] : consult.medical_controls)
end

#Permite traer la informacion del paciente
node :patient do |consult|
  partial("api/v1/patients/information_patient", object: consult.patient)
end

#Permite traer la informacion del paciente
node :patient_information do |consult|
  partial("api/v1/patients/patient_info_web", object: consult.patient_information)
end

#Permite traer las imagenes anexas
node :annex_image do |consult|
  partial("api/v1/annex_images/index", object: consult.annex_images)
end
