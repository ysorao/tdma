object @edited_photos

attributes :id, :commentations, :image_injury_id

node :photo do |imagen|
  #dynamic_images(imagen, 0, imagen.id)
  if imagen.edited_photo.blank?
	  "https://#{request.host}:#{request.port}" + '' + imagen.photo.url
	else
	  "https://#{request.host}:#{request.port}" + '' + imagen.edited_photo.url
	end
end

node :body_area do |imagen|
  imagen.injury.name
end

node :commentations do |imagen|
  #imagen.photo.split("?").first.split("/").last == "edited_photo.png" ? imagen.commentations : ''
  imagen.photo.url == "edited_photo.png" ? imagen.commentations : ''
end
