object @photos

attributes :id, :photo

node :body_area do |img_injury|
  img_injury.nil? ? 'Sin área' : img_injury.injury.body_area.name 
end