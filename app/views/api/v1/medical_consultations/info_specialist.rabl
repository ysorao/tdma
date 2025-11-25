object @specialist_info

attributes :id, :evolution_time, :other_factors_symptom, :aggravating_factors, :personal_history, :applied_substances, :description_physical_examination, :physical_audio, :patient_information_id, :patient_id, :doctor_id, :consultation_id, :reason_consultation, :current_illness

node :treatment_received do |info|
  info.treatment_received.nil? || info.treatment_received.blank? ? 'Ninguno' : info.treatment_received
end

node :treatment_effects do |info|
  info.treatment_effects.nil? || info.treatment_effects.blank? ? 'Ninguno' : info.treatment_effects
end

node :family_background do |info|
  info.family_background.nil? || info.family_background.blank? ? 'Ninguno' : info.family_background
end

node :diagnostic_impression do |info|
  info.diagnostic_impression.nil? || info.diagnostic_impression.blank? ? 'Ninguno' : Disease.find_by(code: info.diagnostic_impression).nil? ? info.diagnostic_impression : Disease.find_by(code: info.diagnostic_impression).name
end

node :weight do |info|
  info.weight.nil? ? 'Ninguno' : info.weight
end

node :name_complete do |info|
  info.consultation.doctor.name.to_s + ' ' + info.consultation.doctor.surnames.to_s 
end

node :annex_audio do |info|
  info.consultation.audio_annex
end

node :bandera do |info|
  if @flag == true
    'ok'
  end
end

node :number_injuries do |info|
  if info.number_injuries == 1
  	'Menos de cinco'
  elsif info.number_injuries == 2
  	'cinco a diez'
  else
    'Más de diez'
  end 
end

node :evolution_injuries do |info|
  lesiones = []
  info.evolution_injuries.split(",").each do |number|
    if number == "1"
      lesiones.push('Estable')
    elsif number == "2"
      lesiones.push('Aumento de tamaño')
    elsif number == "3"
      lesiones.push('Cambio de color')
    elsif number == "4"
      lesiones.push('Aumento de número')
    elsif number == "5"
      lesiones.push('Permanentes')
    elsif number == "6"
      lesiones.push('Progresivas')
    else
      lesiones.push('Recurrentes')
    end
  end
  lesiones.join(", ")
end

node :blood do |info|
  info.blood? ? 'Sí' : 'No'
end

node :exude do |info|
  info.exude? ? 'Sí' : 'No'
end

node :suppurate do |info|
  info.suppurate? ? 'Sí' : 'No'
end

node :unit_measurement do |info|
  if info.unit_measurement == 1
  	'Años'
  elsif info.unit_measurement == 2
  	'Meses'
  else
    'Días'
  end
end

node :symptom do |info|
  sintomas = []
  info.symptom.split(",").each do |number|
    if number == "1"
      sintomas.push('Prurito')
    elsif number == "2"
      sintomas.push('Ardor')
    elsif number == "3"
      sintomas.push('Dolor')
    else
      sintomas.push('Ninguno')
    end
  end
  sintomas.join(", ")
end

node :change_symptom do |info|
  if info.change_symptom == 1
  	'Sí empeoran en el día'
  elsif info.change_symptom == 2
  	'Sí empeoran en la noche'
  else
  	'No'
  end
end

node :annex_description do |info|
  info.consultation.annex_description  
end

node :audio_annex do |info|
  info.consultation.audio_annex
end

node :images_consult do |info|
  info.consultation.annex_images.blank? ? [] : partial("api/v1/annex_images/index", object: info.consultation.annex_images) 
end