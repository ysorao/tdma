#Lista toda la informacion de paciente y su consulta (web)
object @patient_consult

attributes :id, :date_archived, :patient_id, :patient_information_id, :nurse_id

node :annex_description do |consult|
  consult.annex_description.nil? ? 'Ninguno' : consult.annex_description
end

node :audio_annex do |consult|
  consult.audio_annex.nil? ? 'Ninguno' : consult.audio_annex
end

node :nurse_id do |consult|
  consult.nurse.name.to_s + ' ' + consult.nurse.surnames.to_s
end

node :created_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %I:%M:%S")
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
node :nurse_consult do |consult|
  partial("api/v1/nurse_consultations/show", object: consult.nurse_consultation)
end

#Permite traer la informacion de la consulta del control
node :nurse_control do |consult|
  partial("api/v1/nurse_controls/index", object: consult.consultation_controls.blank? ? [] : consult.consultation_controls.first.nurse_control)
end

#Permite traer la informacion del paciente
node :patient do |consult|
  partial("api/v1/patients/information_patient", object: consult.patient)
end

#Permite traer la informacion del paciente
node :patient_information do |consult|
  partial("api/v1/patients/patient_info_web", object: consult.patient_information)
end