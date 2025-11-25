object @medical_consultations

attributes :id, :symptom, :evolution_time, :unit_measurement, :number_injuries, :evolution_injuries, :blood, :exude, :suppurate, :change_symptom, :other_factors_symptom, :aggravating_factors, :personal_history, :applied_substances, :description_physical_examination, :physical_audio, :consultation_id, :reason_consultation, :current_illness

#node :symptom do |info|
	#sintomas = []
  #info.symptom.split(",").each do |number|
	  #if number == "1"
		  #sintomas.push('Purito')
		#elsif number == "2"
		  #sintomas.push('Ardor')
		#elsif number == "3"
		  #sintomas.push('Dolor')
		#else
		  #sintomas.push('Ninguno')
		#end
	#end
	#sintomas.join(", ")
#end

node :aggravating_factors do |info|
  info.aggravating_factors.nil? || info.aggravating_factors.blank? ? 'Ninguno' : info.aggravating_factors
end

node :personal_history do |info|
  info.personal_history.nil? || info.personal_history.blank? ? 'Ninguno' : info.personal_history
end

node :applied_substances do |info|
  info.applied_substances.nil? || info.applied_substances.blank? ? 'Ninguna' : info.applied_substances
end

node :treatment_received do |info|
  info.treatment_received.nil? || info.treatment_received.blank? ? 'Ninguno' : info.treatment_received
end

node :treatment_effects do |info|
  info.treatment_effects.nil? || info.treatment_effects.blank? ? 'Ninguno' : info.treatment_effects
end

node :diagnostic_impression do |info|
  info.diagnostic_impression.nil? || info.diagnostic_impression.blank? ? 'Ninguno' : info.diagnostic_impression
end

node :family_background do |info|
  info.family_background.nil? || info.family_background.blank? ? 'Ninguno' : info.family_background
end

node :weight do |info|
  info.weight.nil? ? 'Ninguno' : info.weight
end

node :reason_consultation do |info|
  info.reason_consultation.nil? || info.reason_consultation.blank? ? 'Ninguno' : info.reason_consultation
end

node :current_illness do |info|
  info.current_illness.nil? || info.current_illness.blank? ? 'Ninguno' : info.current_illness
end

node :created_at do |medical|
  medical.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :updated_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %I:%M %p")
end
