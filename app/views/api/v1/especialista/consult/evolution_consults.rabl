object @consult_control

attributes :id

node :value do |consult|
  if consult.class.name == "Consultation"
    "#{consult.id}-consulta"
  else
    "#{consult.id}-control"
  end
end

node :created_at do |consult|
  if consult.class.name == "Consultation"
    consult.medical_consultation.created_at.strftime("%d/%m/%Y")
  else
    consult.medical_control.created_at.strftime("%d/%m/%Y")
  end
end