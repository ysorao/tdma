class Landing::HomeController < Landing::ModuleController

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-01-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Vista principal
  def index
  end

  # Metodo: Home landing page
  def home
  end

  # Metodo: Acerca de nosotros
  def about_us
  end

  # Metodo: Servicios
  def services
  end

  # Metodo: Soporte
  def support
  end

  # Metodo: Contacto
  def sales_contact
  end

  # Vista terminos y condiciones
  def terms
  end

  #Formulario para el contacto
  def form_contact
    contact = Contact.new(name_complete: params[:name_complete], email: params[:email], phone: params[:phone], message: params[:message], type_contact: params[:type].to_i, status: 1)
		if verify_recaptcha && contact.save
			if params[:type] == "1"
				EmailDocumentation.sales_contact(contact).deliver_now
				redirect_to home_landing_home_index_path, notice: 'Ha sido enviado'
			elsif params[:type] == "2"
				EmailDocumentation.support(contact).deliver_now
			  redirect_to home_landing_home_index_path, notice: 'Ha sido enviado'
			end
		else
      if params[:type] == "1"
        render template: "/landing/home/sales_contact.html.erb"
		  elsif params[:type] == "2"
        render template: "/landing/home/support.html.erb"
      end
    end
  end

  # Metodo: Home landing page
  def event
  end
end