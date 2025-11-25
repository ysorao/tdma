object @insurances

attributes :id, :name, :code, :updated_at

node :value do |dis|
  dis.name
end