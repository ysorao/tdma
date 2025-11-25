object @dermatoscopy

attributes :id, :image_injury_id

node :photo do |img_injury|
  #dynamic_images(img_injury, 0, nil)
  "http://#{request.host}:#{request.port}" + '' + img_injury.photo.url
end