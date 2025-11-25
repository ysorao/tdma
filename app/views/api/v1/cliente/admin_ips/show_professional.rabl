object @professional

attributes :id, :name, :surnames, :number_document, :type_professional, :professional_card, :phone, :email

node :type_professional do |user|
  if user.type_professional == 1
	  'Médico'
	elsif user.type_professional == 2
	  'Enfermera'
	elsif user.type_professional == 3
	  'Auxiliar'
	else
	  'Especialista'
	end
end