# frozen_string_literal: true

class ClientUsers::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @client = Client.new
    @client.ips_insurances.build
    @client.client_users.build
    super
  end

  # POST /resource
  def create
    @client = Client.new(client_params)

    if @client.save
      IpsInsurance.create(client_id: @client.id, insurance_id: Insurance.last.id)
      redirect_to client_user_session_path, notice: "Ha guardado", format: 'js'
    else
      flash[:alert] = @client.errors.full_messages.to_sentence
      render :new, action: @client
    end
    #build_resource(sign_up_params)
    #resource.type_professional = ClientUser::ADMIN_IPS
    #resource.terms_and_conditions = true
    #resource.client_id = client.id
    #resource.save
    #yield resource if block_given?
    #if resource.persisted?
      #if resource.active_for_authentication?
        #set_flash_message! :notice, :signed_up
        #sign_up(resource_name, resource)
        #respond_with resource, location: after_sign_up_path_for(resource)
      #else
        #set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        #expire_data_after_sign_in!
        #respond_with resource, location: after_inactive_sign_up_path_for(resource)
      #end
    #else
      #clean_up_passwords resource
      #set_minimum_password_length
      #respond_with resource
    #end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private
  #Despues de registrarse permite redireccionar al login ignorando el root en routes
  def after_inactive_sign_up_path_for(resource)
    new_client_user_session_path
  end

  def client_params
    params.require(:client).permit(:identification_number, :type_identification, :business_name, :bill_number, :bill_expedition_date, :administrator_entity_code, :administrator_entity_name, :benefits_plan, :policy_number, :total_value_shared_payment, :commision_value, :total_value_discounts, :net_to_pay_contract_entity, ips_insurances_attributes: [:client_id, :insurance_id, :id, :_destroy], client_users_attributes: [:id, :name, :surnames, :phone, :email, :number_document, :type_professional, :password, :password_confirmation, :terms_and_conditions, :client_id])
  end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
