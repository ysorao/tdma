ActiveAdmin.register AdminUser do

  permit_params :email, :name, :surnames, :number_document, :phone, :status, :password, :password_confirmation, :role, :action, :admin
  menu priority: 2, label: "Administradores"

  index do
    column :id
    column :name
    column :surnames
    column :number_document
    column :phone
    column :role do |admin|
      if admin.role == AdminUser::SUPER_ADMIN
        'Super administrador'
      elsif admin.role == AdminUser::ADMIN
        'Administrador'
      else
        'Soporte tecnico'
      end
    end
    column :email
    column :status do |u|
      if u.status == User::ACTIVO
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
        var = "Activo"
      end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Inactivo"
        end
      end
    end
    column :current_sign_in_at
    column :created_at
    actions defaults: false, name: 'Acciones' do |user|
      if user.status == User::ACTIVO && AdminUser.all.first.id != user.id
        item('Desactivar', inactivate_admin_admin_user_path(id: user.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        item("Eliminar", admin_admin_user_path(id: user.id), :method => :delete, :data => {:confirm => "Este usuario puede tener trazabilidad asociada. Está seguro de eliminarlo?"})
      elsif user.status == User::INACTIVO
        item('Activar', activate_admin_admin_user_path(id: user.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        item("Eliminar", admin_admin_user_path(id: user.id), :method => :delete, :data => {:confirm => "Este usuario puede tener trazabilidad asociada. Está seguro de eliminarlo?"})
      end
    end
    actions defaults: false, name: 'Trazabilidad' do |user|
      unless user.traceability_admins.blank?
        item "Ver", admin_traceability_admins_path(id: user)
      end
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :created_at

  form do |f|
    f.inputs "Admin Detalles" do
      f.input :name
      f.input :surnames
      f.input :number_document
      f.input :phone
      f.input :email
      f.input :status, :as => :hidden, :input_html => { :value => 1 }
      f.input :password
      f.input :password_confirmation
      f.input :role, as: :select, collection: [['Super administrador', 1], ['Administrador', 2], ['Soporte técnico', 3]]
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id } 
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 29-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Activa un usuario y actualiza su estado
  member_action :activate, method: :put do
    user = AdminUser.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, activate_admin: true, user_admin_id: user.id)
    user.update_attribute(:status, User::ACTIVO)
    redirect_to admin_admin_users_path(id: user), notice: 'Usuario activado'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 29-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Desactiva un usuario y actualiza su estado
  member_action :inactivate, method: :put do
    user = AdminUser.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, desactivate_admin: true, user_admin_id: user.id)
    user.update_attribute(:status, User::INACTIVO)
    redirect_to admin_admin_users_path(id: user.id), alert: 'Usuario desactivado'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Mostrar
  show :title => 'Información básica' do
    attributes_table do
      row :id
      row :name
      row :surnames
      row :number_document
      row :phone
      row :email
      row :status do |admin|
        if admin.status == User::ACTIVO
          span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Activo"
        end
        else
          span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
            var = "Inactivo"
          end
        end
      end
      row :current_sign_in_at
      row :last_sign_in_at
      row :role do |admin|
        if admin.role == AdminUser::SUPER_ADMIN
          'Super administrador'
        elsif admin.role == AdminUser::ADMIN
          'Administrador'
        else
          'Soporte tecnico'
        end
      end
      row :created_at
    end
  end

  filter :email, :as => :select, collection: AdminUser.all.map{ |adm| [adm.email, adm.id] }
  filter :created_at

  controller do
    # Metodo: Forma correcta de modificar el crear en el recurso de active admin 
    def create
      admin = AdminUser.new(permitted_params[:admin_user]) 
      if admin.save
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, create_admin: true, user_admin_id: admin.id)
        admin.send_reset_password_instructions
        redirect_to admin_admin_users_path
      else
        super do |format|
          redirect_to collection_url and return if resource.valid?
        end
      end
    end

    #Metodo que permite eliminar un administrador si no tiene asociado un ticket
    def destroy
      admin = AdminUser.find(params[:id])
      if admin.role == AdminUser::SOPORTE_TECNICO && admin.help_desks.count > 0
        redirect_to admin_admin_users_path(), alert: "No se puede eliminar ya que tiene asociado tickets de mesa de ayuda."
      else
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_admin: true, name_complete_admin: admin.name.to_s + ' ' + admin.surnames.to_s, document_admin: admin.number_document, rol: admin.role)
        admin.destroy
        respond_to do |format|
          format.html { redirect_to admin_admin_users_path }
        end    
      end
    end
  end
end
