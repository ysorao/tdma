object @diseases

attributes :id, :name, :code

node :value do |dis|
  dis.name
end