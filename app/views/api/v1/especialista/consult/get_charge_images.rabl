object @photos

attributes :id, :photo, :image_injury_id

node :photo do |img_injury|
  #dynamic_images(img_injury, 0, nil)
  "https://#{request.host}:#{request.port}" + '' + img_injury.photo.url
end

node :body_area do |img_injury|
  img_injury.nil? ? 'Sin área' : img_injury.injury.body_area.name 
end

node :son_images do |img_injury|
  ImagesInjury.where(image_injury_id: img_injury.id).count
end
