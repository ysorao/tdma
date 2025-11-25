ActiveAdmin.register SystemManual do
  permit_params :name, :file_manual, :type_manual, :action, :admin
  menu priority: 13
  actions :all, except: [:show] 

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 16-05-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla Manual del sistema
  index do
    column :id
    column :name
    column :file_manual do |sm|
      #raw("<a href='#{dynamic_images(sm, 8, sm.id)}' download>Descargar")
      raw("<a href='#{sm.file_manual.url}' download>Descargar")
    end
    column :type_manual do |sm|
      if sm.type_manual == 1
        'Web especialista'
      elsif sm.type_manual == 2
        'Web IPS'
      elsif sm.type_manual == 3
        'APP'
      else
        'Pagina web'
      end
    end
    actions
  end


  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 16-05-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Manual del sistema' do
      f.input :name
      f.input :file_manual, as: :file
      f.input :type_manual, as: :select, collection: [['Web especialista', 1], ['Web IPS', 2], ['APP', 3], ['Pagina web', 4]]
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 16-05-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Boton ver: Campos que se muestran en el ver
  show do
    attributes_table do
      row :id
      row :name
      row :file_manual do |sm|
        File.basename(sm.file_manual.to_s)
      end
      row :type_manual do |sm|
        if sm.type_manual == 1
          'Web especialista'
        elsif sm.type_manual == 2
          'Web IPS'
        elsif sm.type_manual == 3
          'APP'
        else
          'Pagina web'
        end
      end
    end
  end

  filter :type_manual, as: :select, include_blank: true, collection: [['Web especialista', 1], ['Web IPS', 2], ['APP', 3], ['Pagina web', 4]]
  filter :created_at


  controller do

    def destroy
      manual = SystemManual.find(params[:id]) 
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_manual_system: true, name_manual: manual.name)
      manual.destroy
      respond_to do |format|
        format.html { redirect_to admin_system_manuals_path }
      end      
    end
  end
end
