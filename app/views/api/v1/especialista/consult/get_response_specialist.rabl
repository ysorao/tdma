object @specialist_info

	#Permite traer la informacion del especialista
	node :information do |response_specialist|
	  partial("api/v1/especialista/consult/get_info_specialist", object: response_specialist)
	end