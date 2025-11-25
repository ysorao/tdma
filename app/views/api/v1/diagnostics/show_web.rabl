#Mostrar informacion otros diagnosticos (WEB)
object @principal

attributes :id, :specialist_response_id

node :disease do |diagnostico|
  Disease.find(diagnostico.disease_id).nil? ? 'Ninguno' : Disease.find(diagnostico.disease_id).name  
end

node :type_diagnostic do |diagnostico|
  if diagnostico.type_diagnostic == nil
    'Ninguno'
  elsif diagnostico.type_diagnostic == 1
  	'Impresión diagnóstica'
  elsif diagnostico.type_diagnostic == 2
    'Confirmado nuevo'
  else
    'Confirmado repetido'
  end
end

node :status do |diagnostico|
  diagnostico.status == 0 ? 'Inactivo' : 'Activo'
end

node :created_at do |diagnostico|
  diagnostico.created_at.strftime("%d/%m/%Y %HH:%MM")
end
