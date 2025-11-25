object @images_injuries

attributes :id, :photo, :description, :medical_control_id

node :edited_photo do |injury|
  #dynamic_images(injury, 2, injury.id)
  injury.edited_photo
end

node :created_at do |injury|
  injury.created_at.strftime("%d/%m/%Y %HH:%MM")
end