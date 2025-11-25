object @treatments

attributes :id, :name


node :recommended_treatment do |library|
  library.specialist_response.consultation.nil? ? library.specialist_response.consultation_control.recommended_treatment : library.specialist_response.consultation.recommended_treatment
end