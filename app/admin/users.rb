ActiveAdmin.register User do
	permit_params :photo, :email, :number_document, :type_professional, :type_specialist, :professional_card, :name, :surnames, :phone, :password, :password_confirmation, :terms_and_conditions, :action, :admin      

  actions :all, except: [:show, :edit] 
  menu priority: 3, label: "Profesionales de la salud"
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
    if params[:scope] == "medicos" || params[:scope] == "prof_enfermeria"
      column :name
      column :surnames
      column :email
      column :number_document
      column :phone
      column 'Cliente', :client do |u|
        u.user_clients.first.nil? ? 'Sin cliente' : u.user_clients.first.client.business_name
      end
      column 'Departmento', :department do |u|
        u.user_clients.first.nil? ? 'Sin departamento' : u.user_clients.first.client.municipality.department.name
      end
      column 'Municipio', :municipality do |u|
        u.user_clients.first.nil? ? 'Sin municipio' : u.user_clients.first.client.municipality.name
      end 
      column 'Consultas enviadas', :send_consult do |u|
        if params[:scope] == "medicos"
          u.doctors.count
        elsif params[:scope] == "prof_enfermeria"
          u.nurses.count
        end
      end
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
      column 'Certificado', :certified do |u|
        if u.certified?
          span :class => "", :style => "border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
            var = "Si"
        end
        else
          span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px;" do
            var = "No"
          end
        end
      end
    else
      column :photo do |u|
        u.photo.url.nil? ? 'Sin foto' : image_tag(u.photo.url, :style => "height: 100px")
      end
      column :email
      column :number_document
      column :type_professional do |u|
        if u.type_professional == User::ESPECIALISTA
          'Especialista'
        end
      end
      column :type_specialist do |u|
        if u.type_specialist == User::DERMATOLOGO
          'Dermatologo'
        else
          'Enfermería'
        end
      end
      column :professional_card
      column :name
      column :surnames
      column :phone
      column :terms_and_conditions
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
      column :image_digital do |u|
        u.image_digital.url.blank? ? 'Sin foto' : image_tag(u.image_digital.url, :style => "height: 100px")
      end
      column :tutorial
      column :patients_attended do |u|
        User.attended(u.id)
      end
      column :created_at
      column :updated_at
      actions defaults: true do |user|
        if user.status == User::ACTIVO
          item('Desactivar', inactivate_admin_user_path(id: user.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        elsif user.status == User::INACTIVO
          item('Activar', activate_admin_user_path(id: user.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
        end
      end
    end
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
      f.input :photo, as: :file
      f.input :email
      f.input :number_document
      f.input :type_professional, as: :select, collection: [['Especialista', 4]]
      f.input :type_specialist, as: :select, collection: [['Dermatólogo', 1]]
      f.input :professional_card
      f.input :name
      f.input :surnames
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :terms_and_conditions, as: :select, collection: [['Acepto', true], ['No Acepto', false]]
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 08-04-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Activa un usuario y actualiza su estado
  member_action :activate, method: :put do
    user = User.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, activate_user: true, user_id: user.id)  
    user.update_attribute(:status, User::ACTIVO)
    redirect_to admin_users_path(id: user), notice: 'Especialista activado'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 08-04-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Desactiva un usuario y actualiza su estado
  member_action :inactivate, method: :put do
    user = User.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, desactivate_user: true, user_id: user.id)  
    user.update_attribute(:status, User::INACTIVO)
    redirect_to admin_users_path(id: user.id), alert: 'Especialista desactivado'
  end

  filter :type_professional, as: :select, collection: [['Especialista', 4]]
  filter :status, as: :select, collection: [['Inactivo', 0], ['Activo', 1]]
  filter :type_specialist, as: :select, collection: [['Dermatólogo', 1]]

  scope 'Especialistas', :users_specialist, default: true
  scope 'Médicos', :users_doctor
  #scope 'Prof. enfermería', :users_doctor

  controller do
    def destroy
      user = User.find(params[:id])
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_user: true, name_complete_user: user.name.to_s + ' ' + user.surnames.to_s, document_user: user.number_document, patients_attended: User.attended(user.id))
      user.destroy
      respond_to do |format|
        format.html { redirect_to admin_users_path }
      end     
    end
  end
end
