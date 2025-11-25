ActiveAdmin.register Bill do

permit_params :payment_file, :enabled_payment, :bill_file, :code, :date_expedition, :contract_id, :action, :admin

menu priority: 4
menu :parent => "Clientes", priority: 4

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
    column :contract_id do |con|
      con.contract.contract_number
    end
    column :cliente do |bi|
      bi.contract.client.business_name
    end
    column :enabled_payment do |en|
      if en.enabled_payment?
      span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Verificado"
        end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "No verificado"
        end
      end
    end
    column :code
    column :date_expedition do |bi|
      bi.date_expedition.strftime("%d-%m-%Y %I:%m%P")
    end
    column :payment_file do |pa|
      File.basename(pa.payment_file.to_s)
    end
    column :bill_file do |bi|
      File.basename(bi.bill_file.to_s)
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
    f.inputs 'Factura' do
      f.input :contract_id, as: :select, collection: Contract.all.collect {|u| [u.contract_number, u.id]}
      f.input :bill_file, as: :file
      f.input :code
      f.input :date_expedition, as: :datepicker, datepicker_options: {min_date: 1.month.ago.to_date, max_date: "+1Y"}, input_html: {:readonly => true}
      f.input :payment_file, as: :file
      f.input :enabled_payment
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
      row :contract_id do |con|
        con.contract.contract_number
      end
      row :cliente do |bi|
        bi.contract.client.business_name
      end
      row :payment_file do |pa| 
      	File.basename(pa.payment_file.to_s)
      end
      row :enabled_payment do |en|
        en.enabled_payment? ? 'Verificado' : 'No verificado'
      end
      row :bill_file do |bi|
        File.basename(bi.bill_file.to_s)
      end 
    end
  end

  filter :enabled_payment, as: :select, collection: [['Verificado', true], ['No verificado', false]]
  filter :contract_id, as: :select, collection: Contract.all.map{|u| [u.contract_number, u.id]}
  filter :date_expedition

  controller do

    def destroy
      factura = Bill.find(params[:id])
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_bill: true, code_bill: factura.code, date_expedition: factura.date_expedition, contract_id: factura.contract_id)
      factura.destroy
      respond_to do |format|
        format.html { redirect_to admin_bills_path }
      end    
    end
  end
end
