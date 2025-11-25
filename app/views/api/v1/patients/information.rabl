object @information

attributes :id, :terms_conditions, :unit_measure_age, :age, :civil_status, :phone, :occupation, :email, :address, :municipality_id, :urban_zone, :companion, :name_companion, :phone_companion, :responsible, :name_responsible, :phone_responsible, :relationship, :type_user, :authorization_number, :purpose_consultation, :external_cause, :insurance_id, :patient_id, :status

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

node :created_at do |patient|
  patient.created_at.strftime("%d/%m/%Y %HH:%MM")
end
