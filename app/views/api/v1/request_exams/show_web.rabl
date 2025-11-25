#Mostrar solicitud de examenes (WEB)
object @request_exams

attributes :id, :specialist_response_id

node :name_type_exam do |exam|
  exam.name_type_exam.nil? ? 'Ninguno' : exam.name_type_exam
end