object @consult

attributes :id, :evolution_time, :unit_measurement, :number_injuries, :evolution_injuries, :blood, :exude, :suppurate, :symptom, :change_symptom, :other_factors_symptom, :aggravating_factors, :personal_history, :family_background, :treatment_received, :applied_substances, :treatment_effects, :diagnostic_impression, :description_physical_examination, :physical_audio, :annex_description, :audio_annex, :image_annex, :patient_information_id, :patient_id, :status, :doctor_id, :diagnostic_impression

node :created_at do |consult|
  consult.created_at.strftime("%d/%m/%Y %HH:%MM")
end