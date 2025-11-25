class Api::V1::SessionsController < NoSessionApiController

  include ProofGlobalModule

  acts_as_token_authentication_handler_for User, only: [:update]

  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Iniciar sesión por correo
  #
  # URL: /api/v1/sessions/login.json
  def login
    #sleep 10
    number_card = params[:number_document]
    password = params[:password]
    imei = request.headers["imei"]

    if number_card.blank? || password.blank? || imei.blank?
      render status: 411, json: {error: "No pueden estar vacíos"}
    else
      user = User.find_by_number_document(params[:number_document])
 
      unless user.nil?
        usuario_cliente = UserClient.find_by(user_id: user.id)
        if user.status == User::ACTIVO
          unless validate_imei(imei, user).nil?
            if user.valid_password?(password)
              usuario = User.find(user.id)
              UserToken.create(user_id: user.id, old_token: user.authentication_token)
              user.ensure_authentication_token
              user.save

              render status: 200, json: {
                message: "Excelente, iniciaste sesión",
                user: user
              }
            else
              render status: 411, json: {status: 411, error: "Documento o clave invalida"}
            end
          else
            render status: 411, json: {status: 411, error: "El imei no esta asociado a su IPS o el contrato ha expirado"}
          end
        else
          render status: 411, json: {status: 411, error: "El profesional se encuentra inactivo."}
        end
      else
        render status: 411, json: {status: 411, error: "Documento o clave invalida"}
      end
    end
  end


  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Iniciar sesión por correo
  #
  # URL: /api/v1/sessions/register.json
  def register
    user = User.new(user_params)
    
    if request.headers["imei"].blank?
      render status: 411, json: {error: 'Imei no puede estar vacío'}   
    else
      device = Device.find_by(imei: request.headers["imei"])

      if device.nil?
        render status: 411, json: {error: 'El imei no existe'} 
      elsif device.kit_id.nil?
        render status: 411, json: {error: 'No tiene un kit asociado'}
      else
        #cliente = Client.validate_kit(device)
        device = Device.find(device.id)
        unless device.nil?
          if device.kit.contract.status == Contract::ACTIVO
            ClientUser.create(email: user.email, number_document: user.number_document, type_professional: user.type_professional, professional_card: user.professional_card, name: user.name.to_s, surnames: user.surnames.to_s, phone: user.phone, client_id: device.kit.contract.client_id, status: 1, role: 2, commit: 'app', password: user.password, password_confirmation: user.password_confirmation)
            if user.save
              user_client = UserClient.create(user_id: user.id, client_id: device.kit.contract.client_id)
              #client_user.send_reset_password_instructions
              render status: 200, json: {status: 200, user: user, message: "Excelente, gracias por registraste!"}
            else
              puts "=======> user #{user.errors.inspect}"
              render status: 411, json: {error: 'User has not been register', user: user.errors.messages}
            end
          else
            render status: 411, json: {error: 'Contactese con su IPS'}
          end
        else
          render status: 411, json: {error: 'El dispositivo no existe.'}
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-08-06
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualizar perfil médico
  #
  # URL: /api/v1/sessions/update.json
  def update
    #unless params[:id].nil?
      user = User.find_by_authentication_token(params[:user_token]) 
      if user.nil?
        render status: 411, json: { error: 'El usuario no existe.' }
      else
        if user.update_with_password(user_update_params)
          render status: 200, json: {status: 200, user: user, message: 'Ha sido editado correctamente' }
        else
          puts "=======> user_update #{user.errors.inspect}"
          render status: 411, json: {error: user.errors }
        end
      end
    #else
      #render status: 411, json: { error: 'El id no puede estar vacío.' }
    #end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-08-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualizar inicio de la aplicacion movil tutorial
  #
  # URL: /api/v1/sessions/tutorial.json
  def tutorial
    user = User.find_by_authentication_token(params[:user_token]) 
    if user.nil?
      render status: 411, json: { error: 'El usuario no existe.' }
    else
      user.update_attribute(:tutorial, true)
      render status: 200, json: {status: 200, user: user, message: 'Ha sido editado correctamente' }
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-16
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Recuperar contraseña
  #
  # URL: /api/v1/sessions/forget_password.json
  def forget_password
    user = User.find_by_number_document(params[:number_document])
    
    if user.nil?
      render status: 411, json: {error: 'El número de documento no existe'}
    else
      user.send_reset_password_instructions
      #ForgetPasswordWorker.perform_async(user.id)
      render status: 200, json: {message: "Ha sido enviado un correo para restablecer la contraseña"}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-08-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite mandar al correo la certificación del médico
  #
  # URL: /api/v1/sessions/certificated.json
  def certificated
    if params[:doctor_id].blank? || params[:certified].blank?
      render status: 411, json: {error: 'No puede estar vacío'}
    else
      if User.exists?(params[:doctor_id])
        user = User.find(params[:doctor_id])
        user.update_attribute(:certified, true)
        render status: 200, json: {status: 200, message: "Al correo electrónico registrado se ha enviado el diploma."}  
        EmailDocumentation.certificate_doctor(user).deliver_now
      else
        render status: 411, json: {error: 'El médico no existe'}
      end
    end
  end

  private

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Especifica los parametros fuertes de la tabla user
  def user_params
    params.require(:user).permit(:id, :photo, :number_document, :type_professional, :professional_card, :name, :surnames, :phone, :email, :password, :password_confirmation, :terms_and_conditions, :digital_signature, :image_digital, :tutorial)
  end

  # Metodo: Especifica los parametros fuertes de la tabla user
  def user_update_params
    params.require(:user).permit(:photo, :name, :surnames, :phone, :email, :image_digital, :tutorial, :password, :password_confirmation, :current_password)
  end
end