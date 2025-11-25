ActiveAdmin.register SpecialistResponse do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Mostrar
  show do
		panel "Otros diagnosticos" do
			table_for specialist_response.other_diagnostics, style:"border:0;cellspacing:0;cellpadding:0" do
				column "Diagnostico principal" do |diag|
					diag.principal_diagnostic
				end
				column "Tipo de diagnostico" do |diag|
					if diag.type_diagnostic == OtherDiagnostic::IMPRESIÓN_DIAGNOSTICA
						'Impresión diagnostica'
					elsif diag.type_diagnostic == OtherDiagnostic::CONFIRMADO_NUEVO
            'Confirmado nuevo'
					else
            'Confirmado repetido'
					end
				end
				column "Estado" do |diag|
					diag.status == OtherDiagnostic::ACTIVO ? 'Activo' : 'Inactivo' 
				end
				column "Creado el" do |diag|
					diag.created_at.strftime("%d-%m-%Y %I:%m%P") 
				end
				column "Actualizado el" do |diag|
					diag.updated_at.strftime("%d-%m-%Y %I:%m%P") 
				end
			end
		end

		panel "Archivos Mipres" do
	    MipresFile.where(specialist_response_id: specialist_response.id).each_with_index do |pres, i|
	      i=i+1;
	      table i.to_s do
	        tr do
	          td do 
	          	image_tag(pres.mipres, :style => "width: 100px; height: 50px")
	          	#raw("<a>Hello</a>")
	          end
	        end
	      end
	    end
	  end
	end

  filter :consultation_id, as: :select, collection: Consultation.all.collect {|u| ['Consulta' + ' #' + u.id.to_s, u.id]}
  #filter :medical_control_id, as: :select, collection: MedicalControl.all.collect {|u| ['Control médico' + ' #' + u.id.to_s, u.id]}
end
