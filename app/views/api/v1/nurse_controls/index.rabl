object @nurse_controls

attributes :id, :subjetive_improvement, :ulcer_length, :ulcer_width, :pain_intensity, :tolerated_treatment, :improvement, :consultation_control_id, :commentation

node :created_at do |nurse|
  nurse.created_at.strftime("%d-%m-%Y %I:%M %p")
end

node :nurse_id do |nurse|
  nurse.consultation_control.nurse_id
end

#Permite traer la informacion de la consulta del control
node :consultation_control do |control|
  partial("api/v1/consultation_controls/show_last", object: control.consultation_control)
end


