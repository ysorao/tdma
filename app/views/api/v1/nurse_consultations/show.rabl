object @nurse_consultations

attributes :id, :ulcer_etiology, :ulcer_handle, :ulcer_length, :ulcer_width, :consultation_id

node :ulcer_etiology_other do |consult|
  consult.ulcer_etiology_other.nil? || consult.ulcer_etiology_other.blank? ? 'Ninguno' : consult.ulcer_etiology_other
end

node :infection_signs do |consult|
  consult.infection_signs.nil? || consult.infection_signs.blank? ? 'Ninguno' : consult.infection_signs
end

node :wound_tissue do |consult|
  consult.wound_tissue.nil? || consult.wound_tissue.blank? ? 'Ninguno' : consult.wound_tissue
end

node :weight do |consult|
  consult.weight.nil? ? 'Ninguno' : consult.weight
end

node :skin_among_ulcer do |consult|
  consult.skin_among_ulcer.nil? || consult.skin_among_ulcer.blank? ? 'Ninguno' : consult.skin_among_ulcer
end

node :ulcer_handle_aposito do |consult|
  consult.ulcer_handle_aposito.nil? || consult.ulcer_handle_aposito.blank? ? 'Ninguno' : consult.ulcer_handle_aposito
end

node :ulcer_handle_other do |consult|
  consult.ulcer_handle_other.nil? || consult.ulcer_handle_other.blank? ? 'Ninguno' : consult.ulcer_handle_other
end

node :consultation_reason_description do |consult|
  consult.consultation_reason_description.nil? || consult.consultation_reason_description.blank? ? 'Ninguno' : consult.consultation_reason_description
end

node :consultation_reason_audio do |consult|
  consult.consultation_reason_audio.nil? || consult.consultation_reason_audio.blank? ? 'Ninguno' : consult.consultation_reason_audio
end

node :created_at do |ulcer|
  ulcer.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :pulses_pedio do |ulcer|
	if ulcer.pulses_pedio == NurseConsultation::AUSENTE
    'Ausente'
	elsif ulcer.pulses_pedio == NurseConsultation::DEBIL
    'Debíl'
	else
    'Normal'
	end
end

node :pulses_femoral do |ulcer|
  if ulcer.pulses_pedio == NurseConsultation::AUSENTE
    'Ausente'
	elsif ulcer.pulses_pedio == NurseConsultation::DEBIL
    'Debíl'
	else
    'Normal'
	end
end

node :pulses_tibial do |ulcer|
  if ulcer.pulses_pedio == NurseConsultation::AUSENTE
    'Ausente'
	elsif ulcer.pulses_pedio == NurseConsultation::DEBIL
    'Debíl'
	else
    'Normal'
	end
end