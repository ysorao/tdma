object @sede

attributes :id, :name

node :kit_id do |sede|
  sede.nil? ? '' : sede.kit.code
end

node :created_at do |sede|
  sede.created_at.strftime("%d/%m/%Y")
end

node :department do |sede|
  sede.nil? ? '' : sede.municipality.department.name
end

node :municipality do |sede|
  sede.nil? ? '' : sede.municipality.name
end