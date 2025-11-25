#Lista el diagnostico junto con sus controles (web)
object @principal

#Informacion del diagnostico
node :diagnostic do |diagnostico|
  diagnostico.nil? ? '' : partial("api/v1/diagnostics/show_web", object: diagnostico)
end

#Información de los controles
node :medical_control do |diagnostico|
  diagnostico.nil? ? [] : partial("api/v1/medical_controls/show", object: diagnostico.specialist_response.consultation.medical_controls)
end