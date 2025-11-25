object @images_injuries

attributes :id, :photo, :injury_id, :image_injury_id

node :photo do |image|
  #dynamic_images(image, 0, nil)
  "https://#{request.host}:#{request.port}" + '' + image.photo.url
end

node :description do |injury|
  injury.commentations
end

node(:edited_photo, :if => lambda { |image_injury| !image_injury.edited_photo.url.nil? }) do |image_injury|
  #dynamic_images(image_injury, 2, image_injury.id)
  "https://#{request.host}:#{request.port}" + '' + image_injury.edited_photo.url.to_s
end

node :created_at do |injury|
  injury.created_at.strftime("%d/%m/%Y %HH:%MM")
end