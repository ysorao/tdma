ActiveAdmin.register Client do

permit_params :status, :email, :identification_number, :type_identification, :business_name, :code_service_provider, :municipality_id, :action, :admin

menu priority: 6
menu :parent => "Clientes", priority: 1

actions :all, except: [:destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla user
  index do
    column :id
    column :status do |t|
      if t.status == Client::ACTIVO 
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Activo"
        end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Inactivo"
        end
      end
    end
    column :business_name
    column :email
    column :total_credits do |r|
      if PrepayCardClient.total_credits(r.id) > 0
        PrepayCardClient.total_credits(r.id) + PrepayCard.prepay_additional(r.id)
      else
        0
      end
    end
    column :consumed_credits do |r|
      if PrepayCardClient.total_credits(r.id) > 0
        PrepayCardClient.total_credits(r.id) + PrepayCard.prepay_additional(r.id) -r.available_credits.to_i
      else
        0
      end
    end
    column :available_credits
    column :type_identification do |c|
      if c.type_identification == 1
        'Cédula de ciudadania'
      elsif c.type_identification == 2
        'Cédula de extranjería'
      elsif c.type_identification == 3
        'Carné diplomático'
      elsif c.type_identification == 4
        'Pasaporte'
      elsif c.type_identification == 5
        'Permiso especial permanencia'
      elsif c.type_identification == 6
        'Residente especial paz'
      else
        'Nit'
      end
    end
    column :identification_number
    column :code_service_provider
    column :department do |dep|
      dep.municipality.department.name
    end
    column :municipality_id do |mun|
      mun.municipality.name
    end
    column :created_at
    column :updated_at
    actions defaults: true do |client|
      contrato = Contract.find_by(client_id: client.id)
      if client.client_users.count > 0 && client.contracts.count > 0 && client.prepay_card_clients.count > 0 && contrato.kits.count > 0 && contrato.bills.count > 0
        if client.status == ClientUser::ACTIVO
          item('Desactivar cliente', inactivate_admin_client_path(id: client.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        elsif client.status == ClientUser::INACTIVO
          item('Activar cliente', activate_admin_client_path(id: client.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        end
      end
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Cliente' do
      f.input :status, as: :hidden, input_html: {value: 0}
      f.input :email
      f.input :type_identification, as: :select, collection: [['CEDULA_CIUDADANIA', 1], ['CEDULA_EXTRANJERIA', 2], ['CARNÉ_DIPLOMÁTICO', 3], ['PASAPORTE', 4], ['PERMISO ESPECIAL PERMANENCIA', 5], ['RESIDENTE ESPECIAL PAZ', 6], ['NIT', 7]]
      f.input :identification_number
      f.input :business_name
      f.input :code_service_provider
      if controller.action_name == 'new' || controller.action_name == 'create'
        f.input :created_at, label: 'Departamento', as: :select, collection: options_for_select(Department.order(name: :asc).collect {|u| [u.name, u.id]}), prompt: "Seleccione un departamento", input_html: { id: "department_id", name: "department", onChange: 'change_department_general("department_id", "client_municipality_id", "Seleccione un departamento");'}
        f.input :municipality_id, as: :select, collection: options_from_collection_for_select([], 'id', 'name'), prompt: 'Seleccione una ciudad'
      elsif controller.action_name == 'edit' || controller.action_name == 'update'
        f.input :created_at, label: 'Departamento', as: :select, collection: Department.all.collect{|u| [u.name, u.id]}, selected: Client.find(params[:id]).municipality_id.nil? ? '' : Client.find(params[:id]).municipality.department.id, input_html: {id: "department_id", name: "department", onChange: 'change_department_general("department_id", "client_municipality_id", "Seleccione un departamento");'}
        f.input :municipality_id, as: :select, collection: Municipality.all.collect{|u| [u.name, u.id]}, selected: Client.find(params[:id]).municipality_id.nil? ? nil : Client.find(params[:id]).municipality_id
      end
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Boton ver: Campos que se muestran en el ver
  show do
    attributes_table do
      row :id
      row :status do |t|
        if t.status == Client::ACTIVO
          var = "Activo"
        else
          var = "Inactivo"
        end
      end
      row :email
      row :available_credits
      row :type_identification do |c|
        if c.type_identification == 1
          'Cédula de ciudadania'
        elsif c.type_identification == 2
          'Cédula de extranjería'
        elsif c.type_identification == 3
          'Carné diplomático'
        elsif c.type_identification == 4
          'Pasaporte'
        elsif c.type_identification == 5
          'Permiso espcial permanencia'
        elsif c.type_identification == 6
          'Residente especial paz'
        else
          'Nit'
        end
      end
      row :identification_number
      row :business_name
      row :code_service_provider
      row :department do |dep|
        dep.municipality.department.name
      end
      row :municipality_id do |mun|
        mun.municipality.name
      end
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 07-11-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Desactiva un cliente
  member_action :inactivate, method: :put do
    cliente = Client.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, desactivate_client: true, user_id: cliente.id)  
    cliente.update_attribute(:status, Client::INACTIVO)
    cliente.client_users.update_all(status: Contract::INACTIVO)
    cliente.contracts.update_all(status: Contract::INACTIVO)
    User.user_contract(cliente.id, 0)
    redirect_to admin_clients_path, alert: 'Cliente desactivado'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 07-11-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Activa un cliente y actualiza su estado
  member_action :activate, method: :put do
    cliente = Client.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, activate_client: true, client_id: cliente.id)  
    cliente.update_attribute(:status, Client::ACTIVO)
    cliente.client_users.update_all(status: Contract::ACTIVO)
    cliente.contracts.update_all(status: Contract::ACTIVO)
    usuarios_cliente = ClientUser.where(client_id: cliente.id)
    unless usuarios_cliente.blank?
      usuarios_cliente.each do |usu|
        usu.update_attribute(:password, usu.number_document.to_s + 'aA')
        usu.update_attribute(:password_confirmation, usu.number_document.to_s + 'aA')
        usu.send_reset_password_instructions
      end
      User.user_contract(cliente.id, 1)
    end
    redirect_to admin_clients_path, notice: 'Cliente activado'
  end

  filter :status, as: :select, collection: [["Inactivo", 0], ["Activo", 1]]

  controller do
    # Autor: Orlando Guzman Londono
    #
    # Fecha creacion: 20-09-2018
    #
    # Autor actualizacion:
    #
    # Fecha actualizacion:
    #
    # Metodo: Forma correcta de modificar el crear en el recurso de active admin 
    def create
      @cliente = Client.new(permitted_params[:client])

      if @cliente.save
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, create_client: true, client_id: @cliente.id)  
        IpsInsurance.create([{client_id: @cliente.id, insurance_id: 1680}, {client_id: @cliente.id, insurance_id: 1681}, {client_id: @cliente.id, insurance_id: 1682}])
        redirect_to admin_clients_path
      else
        super do |format|
          redirect_to collection_url and return if resource.valid?
        end
      end
    end
  end
end
