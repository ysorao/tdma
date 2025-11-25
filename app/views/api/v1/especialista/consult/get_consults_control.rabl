object @control


  if @control.class.name == "MedicalConsultation"
	  #Permite traer la informacion de la consulta
	  node :medical_consult do |medical_consult|
	    partial("api/v1/medical_consultations/info_specialist", object: medical_consult, locals: {flag: true})
	  end
	else
    #Permite traer la informacion del control
	  node :medical_control do |medical_control|
	    partial("api/v1/medical_controls/show", object: [medical_control], locals: {flag: true})
	  end
	end

