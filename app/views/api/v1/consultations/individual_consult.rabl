object @show_consults

	attributes :id, :status, :patient_id, :patient_information_id, :specialist_id, :doctor_id, :type_professional
	                    
	node :created_at do |consult|
	  consult.created_at.strftime("%d/%m/%Y %HH:%MM")
	end

	node :patient_information do
	  {}
	end

	node :medical_consultations do 
	  []
	end

	child :consultation_controls do 
	  attributes :id, :status, :consultation_id, :type_professional, :doctor_id
	                       
		node :created_at do |consult_control|
		  consult_control.created_at.strftime("%d/%m/%Y %HH:%MM")
		end

		child :medical_controls do 
		  []
		end

		node :injuries do
		  []
		end

		node :specialist do
		  {}
		end

		node :specialist_response do
		  []
		end

		node :request do
		  []
		end
	end