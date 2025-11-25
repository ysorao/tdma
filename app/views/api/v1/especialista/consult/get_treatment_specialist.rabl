object @treatment

attributes :id

node :recommended_treatment do |treatment|
  treatment.nil? ? nil : treatment.specialist_response.consultation.recommended_treatment
end