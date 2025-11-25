object @injury

attributes :id, :consultation_id, :consultation_control_id, :body_area_id

node :created_at do |injury|
  injury.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :name_area do |injury|
  injury.body_area.name
end

node :images_injuries do |injury|
  injury.nil? ? [] : injury.images_injuries.order(created_at: :asc).map { |injury_image| partial("api/v1/images_injuries/show_injuries", object: injury_image)  }
end

