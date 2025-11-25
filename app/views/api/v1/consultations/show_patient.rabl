object @info_consultations

attributes :id, :annex_description, :audio_annex, :status, :patient_id, :patient_information_id, :specialist_id, :assistant_id, :doctor_id, :nurse_id, :assign_id, :recommended_treatment, :type_profesional, :archived, :diagnostic_impression     

node :created_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %HH:%MM") 
end

child :specialist_responses do
  node :other_diagnostics do |response| 
    response.nil? ? 'No hay respuesta' : response.other_diagnostics.first.as_json
  end
end

node :consultation_controls do |consult|
  consult.nil? ? [] : consult.consultation_controls.map { |control| partial("api/v1/consultation_controls/show", object: control)  }
end

node :count_controls do |consult|
  consult.consultation_controls.blank? ? 0 : consult.consultation_controls.count
end

#Información de las consultas del médico
node :medical_consultation do |consult|
  consult.nil? ? '' : partial("api/v1/medical_consultations/show", object: consult.medical_consultation)
end