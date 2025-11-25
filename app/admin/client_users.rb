ActiveAdmin.register ClientUser do
  
  permit_params :email, :number_document, :type_professional, :professional_card, :name, :surnames, :phone, :client_id, :password, :password_confirmation, :action, :admin      
  actions :all, except: [:destroy]

  menu :parent => "Clientes", priority: 2
  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 23-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla user
  index do
    column :id
    column :status do |cu|
      if cu.status == User::ACTIVO
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Activo"
        end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Inactivo"
        end
      end
    end
    column :name
    column :surnames
    column :client_id do |c|
      c.client_id.nil? ? 'No esta asociado' : c.client.business_name
    end 
    column :email
    column :phone
    column :number_document
    column :type_professional do |cu|
      if cu.type_professional == ClientUser::ADMIN_IPS
        'IPS'
      elsif cu.type_professional == ClientUser::ESE
        'ESE'
      else
        'Profesional independiente'
      end
    end
    column :professional_card
    #column :terms_and_conditions
    column :photo do |cu|
      cu.photo.blank? ? 'Sin foto' : image_tag(cu.photo, :style => "width: 100%; height: 100px")
    end
    column :digital_image do |cu|
      cu.digital_image.blank? ? 'Sin foto' : image_tag(cu.digital_image, :style => "width: 100%; height: 100px")
    end
    column :tutorial
    column :created_at
    column :updated_at
    actions name: 'Acciones'
    actions defaults: false, name: 'Trazabilidad' do |cu|
      unless cu.traceability_clients.blank?
        item "Ver", admin_traceability_clients_path(id: cu.id)
      end
    end
      #if client.status == ClientUser::ACTIVO   
        #item('Desactivar usuario', inactivate_admin_client_user_path(id: client.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
      #elsif client.status == ClientUser::INACTIVO 
        #item('Activar usuario', activate_admin_client_user_path(id: client.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
      #end
    #end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 23-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Usuario' do
      f.input :email
      f.input :number_document
      f.input :type_professional, as: :select, collection: [['IPS', 1], ['ESE', 2], ['PROFESIONAL INDEPENDIENTE', 3]]
      f.input :professional_card
      f.input :name
      f.input :surnames
      f.input :phone
      f.input :client_id, as: :select, :collection => (Client.all.map{|u| [u.business_name, u.id]})
      f.input :password, as: :hidden, input_html: {value: "123456aA"}
      f.input :password_confirmation, as: :hidden, input_html: {value: "123456aA"}
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
      #f.input :terms_and_conditions, as: :select, collection: [['Acepto', true], ['No Acepto', false]]
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
      row :email
      row :number_document
      row :type_professional do |t|
        if t.type_professional == ClientUser::ADMIN_IPS
        'IPS'
        elsif t.type_professional == ClientUser::ESE
          'ESE'
        else
          'Profesional independiente'
        end
      end
      row :professional_card
      row :name
      row :surnames
      row :phone
      row :client_id do |c|
        c.client_id.nil? ? 'No esta asociado' : c.client.business_name
      end
      row :status do |t|
        if t.status == ClientUser::ACTIVO
          var = "Activo"
        else
          var = "Inactivo"
        end
      end
    end

    # if params[:h] == "true"
    #   trace = TraceabilityClient.where(client_user_id: client_user.id)

    #   attributes_table title: 'Trazabilidad del cliente' do
    #     unless trace.blank?
    #       table do
    #         tr do
    #           th "Cliente"
    #           #th "Usuario"
    #           th "Paciente"
    #           th "Compartir historia clinica"
    #           th "Imprimir historia clínica"
    #           th "Asegurador RIPS"
    #           th "Fecha inicio RIPS"
    #           th "Fecha final RIPS"
    #           th "Creado el"
    #         end
    #         trace.each do |inf|
    #           tr do
    #             td do 
    #               inf.client_user.client.business_name
    #             end
    #             #td do 
    #               #inf.client_user.name + inf.client_user.surnames
    #             #end
    #             td do 
    #               inf.patient_id.nil? ? 'N/A' : inf.patient.name.to_s + inf.patient.second_name.to_s + inf.patient.last_name.to_s + inf.patient.second_surname.to_s
    #             end
    #             td do 
    #               inf.shared_clinic_history == true ? 'Sí' : 'No'
    #             end
    #             td do 
    #               inf.print_clinic_history == true ? 'Sí' : 'No'
    #             end
    #             td do 
    #               inf.insurance_id.nil? ? 'N/A' : inf.insurance.name
    #             end
    #             td do 
    #               inf.init_date.nil? ? 'N/A' : inf.init_date.strftime("%d-%m-%Y %I:%m%P")
    #             end
    #             td do 
    #               inf.end_date.nil? ? 'N/A' : inf.end_date.strftime("%d-%m-%Y %I:%m%P")
    #             end
    #             td do 
    #               inf.created_at.strftime("%d-%m-%Y %I:%m%P")
    #             end
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 08-04-2016
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Activa un usuario y actualiza su estado
  member_action :activate, method: :put do
    user = ClientUser.find(params[:id])
    user.update_attribute(:status, ClientUser::ACTIVO)
    #user.send_reset_password_instructions
    redirect_to admin_clients_path, notice: 'Usuario activado'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 08-04-2016
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Desactiva un usuario y actualiza su estado
  member_action :inactivate, method: :put do
    user = ClientUser.find(params[:id])
    user.update_attribute(:status, ClientUser::INACTIVO)
    redirect_to admin_clients_path, alert: 'Usuario desactivado'
  end

  filter :type_professional, as: :select, collection: [['IPS', 1], ['ESE', 2], ['PROFESIONAL INDEPENDIENTE', 3]]
  filter :status, as: :select, collection: [['Inactivo', 0], ['Activo', 1]]
end
