object @patient

  attributes :id, :type_document, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname, :birthdate, :genre, :number_inpec

  #node :name_complete do |patient|
    #patient.name.to_s + ' ' + patient.second_name.to_s + ' ' + patient.last_name.to_s + ' ' + patient.second_surname.to_s
  #end

  node :created_at do |patient|
    patient.created_at.strftime("%d/%m/%Y %HH:%MM")
  end

  node :status do |patient|
    patient.patient_informations.last.status
  end

	#Permite traer las consultas del paciente
	node :consultants do |patient|
	  patient.nil? ? [] : patient.consultations.order(updated_at: :desc).map { |consult| partial("api/v1/consultations/all_consult", object: consult)  }
	end