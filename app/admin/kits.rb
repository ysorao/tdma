ActiveAdmin.register Kit do

permit_params :code, :contract_id, :is_comodato, :action, :admin, devices_attributes: [:imei, :app_version_id, :cell_brand, :system_version, :kit_id, :observations]
actions :all, except: [:edit]

menu priority: 7
menu :parent => "Kits", priority: 2


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
    column :is_comodato do |com|
      if com.is_comodato?
        span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Si"
        end
      else
        span :class => "", :style => "border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "No"
        end
      end
    end
    column :code
    column :cliente do |cont|
      cont.contract.nil? ? 'No esta asociado' : cont.contract.client.business_name
    end
    column :contract_id do |cont|
      cont.contract_id.nil? ? 'No esta asociado' : cont.contract.contract_number
    end
    #column :code_verified
    column :init_date do |ini|
      ini.contract_id.nil? ? 'Sin fecha' : ini.contract.date_init.strftime("%d-%m-%Y")
    end
    column :end_date do |en|
      if en.contract_id.nil?
        'Sin fecha'
      elsif en.contract.date_end_addition.nil?
        en.contract.date_end.strftime("%d-%m-%Y")
      else
        en.contract.date_end_addition.strftime("%d-%m-%Y")
      end
    end
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
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Kit' do
      #f.input :prepay_card_client_id, as: :select, :collection => (PrepayCardClient.all.map{|u| [u.prepay_card.name, u.id]})
      f.input :code
      f.input :contract_id, as: :select, :collection => (Contract.all.map{|u| [u.contract_number, u.id]})
      f.input :is_comodato, as: :select, collection: [['Si', true], ['No', false]]
      f.has_many :devices do |dv|
        dv.input :imei
        dv.input :app_version_id, as: :select, collection: AppVersion.all.collect {|u| [u.version_movil, u.id]}
        dv.input :cell_brand
        dv.input :system_version
        dv.input :observations 
      end
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 11-02-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Boton ver: Campos que se muestran en el ver
  show do
    attributes_table do
      row :id
      row :code
      row :contract_id do |cont|
        cont.contract.contract_number
      end
      row :code_verified
      row :is_comodato do |com|
        if com.is_comodato?
          span :class => "", :style => "border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
            var = "Si"
          end
        else
          span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px;" do
            var = "No"
          end
        end
      end
      row :init_date do |ini|
        ini.contract.date_init.strftime("%d-%m-%Y")
      end
      row :end_date do |en|
        if en.contract.date_end_addition.nil?
          en.contract.date_end.strftime("%d-%m-%Y")
        else
          en.contract.date_end_addition.strftime("%d-%m-%Y")
        end
      end
      #Tarjetas prepago
      row :Dispositivos do |k|
        table do
          tr do
            th "imei"
            th "Versión aplicación"
            th "Marca"
            th "Versión del celular"
            th "Observaciones"
          end
          k.devices.where(kit_id: k.id).each do |disp|
            tr do
              td do 
                disp.imei
              end
              td do
                disp.app_version_id.nil? ? 'No tiene' : AppVersion.find(disp.app_version_id).version_movil
              end
              td do 
                disp.cell_brand
              end
              td do 
                disp.system_version
              end
              td do 
                disp.observations
              end
            end
          end
        end
      end
    end
  end

  filter :is_comodato, as: :select, collection: [['Si', true], ['No', false]]

  controller do

    def new
      @kit = Kit.new
      @kit.devices.build
    end

    #Metodo que permite eliminar un kit con sus dispositivos
    def destroy
      kit = Kit.find(params[:id])
      if kit.help_desks.count > 0
        redirect_to admin_kits_path(), alert: "No se puede eliminar el kit porque su(s) dispositivo(s) estan asociados a tickets de mesa de ayuda"
      else
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_kit: true, code_kit: kit.code, is_comodato: kit.is_comodato? ? 'Sí' : 'No', client_id: kit.contract.client_id, contract_id: kit.contract_id)
        kit.destroy
        respond_to do |format|
          format.html { redirect_to admin_kits_path }
        end    
      end
    end
  end
end