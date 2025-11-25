object @aseguradora

attributes :id

node :client_name do |ins|
  ins.nil? ? 'No tiene asociado cliente' : ins.client.business_name
end

node :insurance_name do |ins|
  ins.nil? ? 'No tiene asociado cliente' : ins.insurance.name
end

node :code do |ins|
  ins.nil? ? '' : ins.insurance.code
end