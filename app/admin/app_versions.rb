ActiveAdmin.register AppVersion do

permit_params :apk_file, :version_movil, :description, :action, :admin
menu priority: 14

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
    column :apk_file
    column :version_movil
    column :description
    actions
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
    f.inputs 'Versiones app' do
      f.input :apk_file, as: :file
      f.input :version_movil
      f.input :description, as: :text
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  controller do

    def destroy
      version = AppVersion.find(params[:id])
      if version.devices.count > 0
        redirect_to admin_app_versions_path(), alert: "No se puede eliminar ya que tiene dispositivos asociados."
      else 
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_version: true, file_name: version.apk_file)
        version.destroy
        respond_to do |format|
          format.html { redirect_to admin_app_versions_path }
        end
      end      
    end
  end
end
