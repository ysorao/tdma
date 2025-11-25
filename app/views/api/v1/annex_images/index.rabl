#Lista las imagenes anexas de una consulta o control
object @annex_images

attributes :id, :annex_url, :consultation_id, :consultation_control_id

node :annex_url do |image|
  #dynamic_images(image, 1, nil)
  "https://#{request.host}:#{request.port}" + '' + image.annex_url.url
end