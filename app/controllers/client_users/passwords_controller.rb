class ClientUsers::PasswordsController < Devise::PasswordsController
    before_action :assert_reset_token_passed, only: [:edit]

    # GET /resource/password/edit?reset_password_token=abcdef
    def edit
      super

      user = ClientUser.find_by_email(params[:m])
      unless user.reset_password_period_valid?
        set_flash_message(:alert, :expired_password)
        redirect_to new_client_user_session_path()
      end
    end

    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message(:notice, flash_message)
          sign_in(resource_name, resource)
        else
          set_flash_message(:notice, :updated_not_active)
        end
        respond_with resource, location: after_resetting_password_path_for(resource)
      else
        #Permite manejar la excepcion cuando el token expira dentro del controlador update
        if resource.errors[:reset_password_token].count > 0
          set_flash_message(:alert, :expired_password)
          redirect_to new_client_user_session_path()
        else
          set_minimum_password_length
          respond_with resource
        end
      end
    end

  protected

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 11-10-2017
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Verifica si el token ya fue usado desde el correo para redireccionarlo al login
  def assert_reset_token_passed
    user = ClientUser.find_by_email(params[:m])
    if user.reset_password_token.nil?
      set_flash_message(:alert, :message)
     redirect_to new_client_user_session_path()
    end
  end
end
