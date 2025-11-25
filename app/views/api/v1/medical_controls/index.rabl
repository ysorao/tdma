object @medical_controls

attributes :id, :doctor_id, :consultation_control_id, :subjetive_improvement, :did_treatment, :tolerated_medications, :audio_clinic, :clinic_description, :audio_annex, :annex_description, :annex_photo

node :created_at do |control|
  control.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :annex_description do |info|
  info.annex_description.nil? || info.annex_description.blank? ? 'Ninguno' : info.annex_description
end

node :clinic_description do |info|
  info.clinic_description.nil? || info.clinic_description.blank? ? 'Ninguno' : info.clinic_description
end

node :status do |estado|
  case estado.status
    when 1
      1
    when 2
      2
    when 3
      3
    when 4
      4
    when 5
      5
    when 6
      6
    else
      'No existe el estado'
  end
end