object @consultation_control

attributes :id, :status, :type_professional, :consultation_id

node :created_at do |consult_control|
  consult_control.created_at.strftime("%d/%m/%Y %HH:%MM")
end

#Informacion del requerimiento de control
node :request do |consult_control|
  partial("api/v1/request/show_web", object: consult_control.requests.order(:id))
end