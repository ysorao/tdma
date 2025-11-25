class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :cors_set_access_control_headers

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 26-06-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: de Devise encargado para redireccionar despues
  # del login a una vista en especifico
  def after_sign_in_path_for(resource)
    if resource.is_a?(AdminUser)
      if resource.status == AdminUser::ACTIVO
        return admin_root_path
      else
        sign_out(resource)
        flash[:alert] = "El cliente o el usuario no se encuentra activado o no existe, contactarse con el Super administrador"
        return new_admin_user_session_path
      end
		end
		if resource.class.name.to_s == "User"
			if (resource.type_professional == User::ESPECIALISTA && resource.type_specialist == User::DERMATOLOGO && resource.status == User::ACTIVO) || resource.type_professional == User::AUXILIAR
			  specialists_especialista_path(status: Consultation::PENDIENTE, option: 1)     	
      elsif (resource.type_professional == User::ESPECIALISTA && resource.type_specialist == User::ENFERMERIA && resource.status == User::ACTIVO)
        nurses_enfermera_index_path(status: Consultation::PENDIENTE, option: 1)
      else
        sign_out(resource)
        new_user_session_path
      end
		elsif resource.class.name.to_s == "ClientUser"
      if resource.client.status == Client::ACTIVO && resource.status == ClientUser::ACTIVO
        if (resource.type_professional == ClientUser::ADMIN_IPS || resource.type_professional == ClientUser::ESE || resource.type_professional == ClientUser::PROFESIONAL_INDEPENDIENTE) && resource.status == ClientUser::ACTIVO
  			  if resource.role == ClientUser::ADMIN
            subsidiaries_clients_cliente_index_path
          else
            search_patient_clients_cliente_index_path
          end     	
        else
          sign_out(resource)
          flash[:alert] = "El usuario no se encuentra activo o no existe."
          new_client_user_session_path
        end
      else
        sign_out(resource)
        flash[:alert] = "El cliente o el usuario no se encuentran activados o no existen, contactarse con Telederma"
        new_client_user_session_path
      end
		end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  #Role admin
  def current_ability
    @current_ability ||= Ability.new(current_admin_user) 
  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
