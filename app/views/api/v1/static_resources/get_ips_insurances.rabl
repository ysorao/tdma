object @ips_aseguradoras

attributes :id, :client_id

node :insurance do |ips|
  ips.insurance.name
end
