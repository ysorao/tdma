ActiveAdmin.register Device do

#actions :all, except: [:destroy]
permit_params :kit_id, :imei, :app_version_id, :cell_brand, :system_version, :observations, :action, :admin

menu priority: 7
menu :parent => "Kits", priority: 1

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion: Orlando Guzman Londono
  #
  # Fecha actualizacion: 11-02-2019
  #
  # Metodo: Muestra los campos de la tabla user
  index do
    column :id
    column :kit_id do |app|
      app.kit.nil? ? 'No esta asociado' : app.kit.code
    end
    column :imei
    column :app_version_id do |app|
      app.app_version_id.nil? ? 'No esta asociado' : app.app_version.version_movil
    end
    column :cell_brand
    column :system_version
    column :observations
    actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 08-04-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Dispositivo' do
      f.input :kit_id, as: :select, include_blank: false, :collection => (Kit.all.map{|u| [u.code, u.id]})
      f.input :imei
      f.input :app_version_id, as: :select, include_blank: false, :collection => (AppVersion.all.map{|u| [u.version_movil, u.id]})
      f.input :cell_brand
      f.input :system_version
      f.input :observations
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  filter :kit_id, as: :select, :collection => (Kit.all.map{|u| [u.code, u.id]}) 
  filter :app_version_id, as: :select, collection: AppVersion.all.collect {|u| [u.version_movil, u.id]}
  filter :cell_brand
  filter :system_version

  controller do
    #Metodo que permite eliminar un dispositivo
    def destroy
      disp = Device.find(params[:id])
      if disp.help_desks.count > 0
        redirect_to admin_devices_path(), alert: "No se puede eliminar el dispositivo ya que tiene asociados tickets de mesa de ayuda"
      else
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_device: true, imei: disp.imei, kit_id: disp.kit_id)
        disp.destroy
        respond_to do |format|
          format.html { redirect_to admin_devices_path }
        end    
      end
    end
  end
end