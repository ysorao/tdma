object @information_patient

attributes :id, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname, :birthdate, :number_inpec

node :second_name do |info|
  info.second_name.nil? ? 'No reporta' : info.second_name
end

node :second_surname do |info|
  info.second_surname.nil? ? 'No reporta' : info.second_surname
end

node :birthdate do |info|
  info.birthdate.nil? ? 'No reporta' : info.birthdate
end

node :number_inpec do |info|
  info.number_inpec.nil? ? 'No reporta' : info.number_inpec
end

node :type_document do |info|
  if info.type_document == 1
  	'Cédula de ciudadania'
  elsif info.type_document == 2
    'Cédula de extranjería'
  elsif info.type_document == 3
  	'Carné diplomatico'
  elsif info.type_document == 4
  	'Pasaporte'
  elsif info.type_document == 5
  	'Salvoconducto'
  elsif info.type_document == 6
  	'Permiso especial de permanencia'
  elsif info.type_document == 7
  	'Residencia especial para la paz'
  elsif info.type_document == 8
  	'Registro civil'
  elsif info.type_document == 9
  	'Tarjeta de identidad'
  elsif info.type_document == 10
  	'Certificado de nacido vivo'
  elsif info.type_document == 11
  	'Adulto sin identificar'
  else
    'Menor sin identificar'
  end
end

node :type_condition do |info|
  if info.type_condition == 1
    'Tercera edad'
  elsif info.type_condition == 2
    'Indigena mayor de edad'
  elsif info.type_condition == 3
    'Habitante de la calle mayor de edad'
  elsif info.type_condition == 4
    'Habitante de la calle menor de edad'
  elsif info.type_condition == 5
    'Menor de edad bajo protección del ICBF'
  elsif info.type_condition == 6
    'Indigena menor de edad'
  elsif info.type_condition == 7
    'Menor de edad reciend nacido'
  elsif info.type_condition == 8
    'Víctima menor de edad'
  elsif info.type_condition == 9
    'Víctima mayor de edad'
  elsif info.type_condition == 10
    'Población reclusa'
  else
    nil
  end
end

node :created_at do |info|
  info.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :created_web do |consult|
  consult.created_at.strftime("%d/%m/%Y")
end

node :hour_at do |info|
  info.created_at.strftime("%I:%M %p")
end

node :genre do |info|
  info.genre == Patient::MASCULINO ? 'Masculino' : 'Femenino'
end