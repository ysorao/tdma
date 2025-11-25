object @specialist

attributes :id

node :value do |consult|
  if consult.class.name == "Consultation"
    "#{consult.id}-consulta"
  else
    "#{consult.id}-control"
  end
end

node :created_at do |consult|
  consult.specialist_responses.first.created_at.strftime("%d/%m/%Y")
end