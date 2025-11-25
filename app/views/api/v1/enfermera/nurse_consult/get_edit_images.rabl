object @edited_photos

attributes :commentations

node :photo do |imagen|
  imagen.photo
end

node :body_area do |imagen|
  imagen.injury.name
end

node :commentations do |imagen|
  imagen.photo.split("/").last == "edited_photo.png" ? imagen.commentations : ''
end