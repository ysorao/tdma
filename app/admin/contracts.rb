ActiveAdmin.register Contract do

permit_params :status, :agreement_date, :date_init, :date_end, :contract_number, :client_id, :action, :admin, prepay_card_clients_attributes: [:purchase_date, :prepay_card_id]

menu priority: 4
menu :parent => "Clientes", priority: 3

actions :all, :except => [:edit]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-02-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla user
  index do
    column :id
    column :status do |t|
      if t.status == 1
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Activo"
        end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Inactivo"
        end
      end
    end
    column :client_id do |c|
      c.client_id.nil? ? 'No esta asociado' : c.client.business_name
    end
    column :contract_number
    column :agreement_date do |d|
      d.agreement_date.strftime("%d-%m-%Y")
    end
    column :date_init do |d|
      d.date_init.strftime("%d-%m-%Y")
    end
    column :date_end do |d|
      d.date_end.strftime("%d-%m-%Y")
    end
    column :created_at
    column :updated_at
    actions
  end


  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-02-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Contrato' do
      f.input :status, as: :hidden, input_html: {value: 0}
      f.input :agreement_date, as: :datepicker, datepicker_options: {min_date: Date.today, max_date: "+5Y"}, input_html: {:readonly => true}
      f.input :date_init, as: :datepicker, datepicker_options: {min_date: Date.today, max_date: "+5Y"}, input_html: {:readonly => true}
      f.input :date_end, as: :datepicker, datepicker_options: {min_date: Date.today, max_date: "+5Y"}, input_html: {:readonly => true}
      f.input :contract_number
      f.input :client_id, as: :select, :collection => (Client.all.map{|u| [u.business_name, u.id]})
      f.has_many :prepay_card_clients do |pr|
        pr.input :purchase_date, as: :datepicker, datepicker_options: {min_date: Date.today, max_date: "+5Y"}, input_html: {:readonly => true}
        pr.input :prepay_card_id, as: :select, collection: PrepayCard.all.collect {|u| [u.name, u.id]} 
      end
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
	  end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-02-2019
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
        if t.status == 1
          var = "Activo"
        else
          var = "Inactivo"
        end
      end
      #row :client_id do |c|
        #c.client_id.nil? ? 'No esta asociado' : c.client.business_name
      #end
      row :contract_number
      row :agreement_date
      row :date_init
      row :date_end
      #Cliente
      row :Cliente do |c|
        table do
          tr do
            th "Estado"
            th "Correo electrónico"
            th "Tipo de identificacion"
            th "Número de identificacion"
            th "Nombre de la IPS o profesional independiente"
            th "Código prestador de salud"
            th "Municipio"
          end  
          tr do
            td do 
              if c.client.status == Client::ACTIVO
                var = "Activo"
              else
                var = "Inactivo"
              end
            end
            td do 
              c.client.email
            end
            td do
              Client.type_document(c.client)
            end
            td do 
              c.client.identification_number
            end
            td do
              c.client.business_name
            end
            td do
              c.client.code_service_provider
            end
            td do
              Municipality.find(c.client.municipality_id).name
            end
          end 
        end
      end

      #Facturas
      #row :Facturas do |c|
        #table do
	        #tr do
	          #th "Archivo de pago"
	          #th "Pago habilitado"
	          #th "Archivo de factura"
	          #th "Código"
	          #th "Fecha de expedición"
	        #end
	        #c.bills.where(contract_id: c.id).each do |factura|
            #tr do
              #td do 
                #File.basename(factura.payment_file.to_s)
              #end
              #td do
                #if factura.enabled_payment
          				#var = "Activo"
        				#else
          				#var = "Inactivo"
        				#end
              #end
              #td do 
                #File.basename(factura.bill_file.to_s)
                #raw("<a href='#{factura.bill_file.to_s}' download>#{File.basename(factura.bill_file.to_s)}")
              #end
              #td do
              	#factura.code
              #end
              #td do
              	#factura.date_expedition.strftime("%d-%m-%Y")
              #end
            #end
          #end
        #end
      #end
      #Tarjetas prepago
      row :Tarjetas do |c|
        table do
          tr do
            th "Fecha de compra"
            th "Tarjeta de prepago"
            th "Cliente"
          end
          c.prepay_card_clients.where(contract_id: c.id).each do |tarjeta|
            tr do
              td do 
                tarjeta.purchase_date.strftime("%d-%m-%Y")
              end
              td do 
                PrepayCard.find(tarjeta.prepay_card_id).name
              end
              td do 
                Client.find(tarjeta.client_id).business_name
              end
            end
          end
        end
      end
      row :created_at
      row :updated_at
    end
  end

  filter :status, as: :select, include_blank: false, collection: [["Inactivo", 0], ["Activo", 1]]
  filter :client_id, as: :select, :collection => (Client.all.map{|u| [u.business_name, u.id]})

  controller do

    #Vista del new
    def new
      @contract = Contract.new
      @contract.prepay_card_clients.build
    end

    #Metodo que permite eliminar un contrato y sus tarjetas
    def destroy
      contrato = Contract.find(params[:id])
      if contrato.kits.count > 0 || contrato.bills.count > 0 || contrato.additional_cards.count > 0
        redirect_to admin_contracts_path(), alert: "No se puede eliminar el contrato ya que la información de kits o facturas esta diligenciada."
      else
        contrato.client.update_attribute(:available_credits, contrato.client.available_credits - PrepayCardClient.total_credits(contrato.client.id))
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_contract: true, contract_number: contrato.contract_number, date_init: contrato.date_init, date_end: contrato.date_end, client_id: contrato.client_id)
        contrato.destroy
        respond_to do |format|
          format.html { redirect_to admin_contracts_path }
        end    
      end
    end
  end
end


