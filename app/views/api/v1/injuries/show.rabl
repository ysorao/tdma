object @injury

attributes :id, :consultation_id, :body_area_id

node :created_at do |injury|
  consult.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :name_area do |injury|
  injury.body_area.name
end