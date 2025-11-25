object @information

attributes :id, :terms_conditions, :age, :phone, :occupation, :address, :companion, :name_companion, :phone_companion, :responsible, :name_responsible, :phone_responsible, :relationship, :authorization_number, :insurance_id, :patient_id, :status

node :phone do |info|
  info.phone.nil? || info.phone.blank? ? 'No reporta' : info.phone
end

node :occupation do |info|
  info.occupation.nil? || info.occupation.blank? ? 'No reporta' : info.occupation
end

node :address do |info|
  info.address.nil? || info.address.blank? ? 'No reporta' : info.address
end

node :email do |info|
  info.email.nil? || info.email.blank? ? 'No reporta' : info.email
end

node :companion do |info|
  info.companion? ? info.companion : false
end

node :name_companion do |info|
  info.name_companion.nil? || info.name_companion.blank? ? 'No reporta' : info.name_companion
end

node :phone_companion do |info|
  info.phone_companion.nil? || info.phone_companion.blank? ? 'No reporta' : info.phone_companion
end

node :responsible do |info|
  info.responsible? ? info.responsible : false
end

node :name_responsible do |info|
  info.name_responsible.nil? || info.name_responsible.blank? ? 'No reporta' : info.name_responsible 
end

node :phone_responsible do |info|
  info.phone_responsible.nil? || info.phone_responsible.blank? ? 'No reporta' : info.phone_responsible
end

node :relationship do |info|
  info.relationship.nil? || info.relationship.blank? ? 'No reporta' : info.relationship
end

node :authorization_number do |info|
  info.authorization_number.nil? || info.authorization_number.blank? ? 'No reporta' : info.authorization_number
end

node :insurance_id do |info|
  info.insurance_id.nil? || info.insurance_id.blank? ? 'No reporta' : Insurance.find(info.insurance_id).name
end

node :created_at do |info|
  info.created_at.strftime("%d/%m/%Y %HH:%MM")
end

node :civil_status do |info|
  if info.civil_status == 1
  	'Soltero(a)'
  elsif info.civil_status == 2
  	'Casado(a)'
  elsif info.civil_status == 3
    'Union Libre'
  elsif info.civil_status == 4
    'Viudo'
  else
    'Separado o Divorciado'
  end 
end

node :department_id do |info|
  Department.find(info.municipality.department_id).name
end

node :municipality_id do |info|
  info.municipality.name
end

node :urban_zone do |info|
  info.urban_zone == 1 ? 'Urbana' : 'Rural'
end

node :unit_measure_age do |info|
  if info.unit_measure_age == 1
  	'Años'
  elsif info.unit_measure_age == 2
  	'Meses'
  else
    'Días'
  end 
end

node :type_user do |info|
  if info.type_user == 1
  	'Contributivo'
  elsif info.type_user == 2
  	'Subsidiado'
  elsif info.type_user == 3
    'Vinculado'
  elsif info.type_user == 4
    'Particular'
  elsif info.type_user == 5
    'Otro'
  elsif info.type_user == 6
    'Víctima afiliación regimen contributivo'
  elsif info.type_user == 7
    'Víctima afiliación regimen subsidiado'
  else
    'Víctima no asegurado'
  end
end

node :purpose_consultation do |info|
  if info.purpose_consultation == 1
    'No aplica'
  elsif info.purpose_consultation == 2
  	'Atención parto'
  elsif info.purpose_consultation == 3
  	'Atención recien nacido'
  elsif info.purpose_consultation == 4
    'Atención planificación familiar'
  elsif info.purpose_consultation == 5
    'Crecimiento y desarrollo menor diez años'
  elsif info.purpose_consultation == 6
    'Alteraciones del desarrollo joven'
  elsif info.purpose_consultation == 7
    'Alteraciones del embarazo'
  elsif info.purpose_consultation == 8
    'Alteraciones del adulto'
  elsif info.purpose_consultation == 9
    'Alteraciones de agudeza visual'
  else
    'Enfermedad profesional'
  end 
end

node :external_cause do |info|
  if info.external_cause == 1
    'Enfermedad general'
  elsif info.external_cause == 2
  	'Accidente de trabajo'
  elsif info.external_cause == 3
  	'Accidente de transito'
  elsif info.external_cause == 4
    'Accidente rábico'
  elsif info.external_cause == 5
    'Accidente ofídico'
  elsif info.external_cause == 6
    'Otro tipo de accidente'
  elsif info.external_cause == 7
    'Evento catastrófico'
  elsif info.external_cause == 8
    'Lesión por agresión'
  elsif info.external_cause == 9
    'Lesión autoinflingida'
  elsif info.external_cause == 10
    'Sospecha de maltrato físico'
  elsif info.external_cause == 11
    'Sospecha de abuso sexual'
  elsif info.external_cause == 12
    'Sospecha de violencia sexual'
  elsif info.external_cause == 13
    'Sospecha de maltrato emocional'
  elsif info.external_cause == 14
    'Enfermedad laboral'
  else
    'Otra'
  end
end