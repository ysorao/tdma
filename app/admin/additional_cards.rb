ActiveAdmin.register AdditionalCard do
 
actions :all, except: [:edit, :destroy] 
permit_params :contract_id, :client_id, :prepay_card_id, :status, :end_date

menu priority: 4
menu :parent => "Clientes", priority: 6

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-02-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla adicionar tarjetas
  index do
    column :id
    column :contract_id do |c|
      c.contract_id.nil? ? 'No esta asociado' : c.contract.contract_number
    end
    column :client_id do |c|
      c.client_id.nil? ? 'No esta asociado' : c.client.business_name
    end
    column :prepay_card_id do |c|
      c.prepay_card_id.nil? ? 'No esta asociado' : c.prepay_card.name
    end  
    column :status do |c|
			if c.status == AdditionalCard::ACTIVO
			  span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
			    var = "Activo"
			  end
			else
			  span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
			    var = "Inactivo"
			  end
			end
		end
    column :end_date do |d|
      d.end_date.strftime("%d-%m-%Y")
    end
    column :created_at
    column :updated_at
    actions defaults: true do |card|
      if card.status == AdditionalCard::INACTIVO
        item('Activación', activate_admin_additional_card_path(id: card.id), data: { confirm: 'Estas Seguro de activarla?', method: :put }, method: :put, class: "member_link")
      end
    end
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
    f.inputs 'Tarjeta adicional' do
      f.input :contract_id, as: :select, :collection => (Contract.all.map{|u| [u.contract_number, u.id]})
      f.input :prepay_card_id, as: :select, collection: PrepayCard.all.collect {|u| [u.name, u.id]}
	    f.input :end_date, as: :datepicker, datepicker_options: {min_date: Date.today, max_date: "+5Y"}, input_html: {:readonly => true}
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
      row :status do |c|
        if c.status == 1
          var = "Activo"
        else
          var = "Inactivo"
        end
      end
      row :contract_id do |c|
      c.contract_id.nil? ? 'No esta asociado' : c.contract.contract_number
	    end
	    row :client_id do |c|
	      c.client_id.nil? ? 'No esta asociado' : c.client.business_name
	    end
	    row :prepay_card_id do |c|
	      c.prepay_card_id.nil? ? 'No esta asociado' : c.prepay_card.name
	    end
      row :end_date do |c|
        c.end_date.strftime("%d-%m-%Y")
      end
	    row :created_at
	    row :updated_at
    end
  end

  # Metodo: Activa una tarjeta adicional y suma creditos al cliente
  member_action :activate, method: :put do
    card = AdditionalCard.find(params[:id])
    TraceabilityAdmin.create(admin_user_id: current_admin_user.id, create_addition_contract: true, additional_card_id: card.id)
    card.update_attribute(:status, AdditionalCard::ACTIVO)
    card.client.update_attribute(:available_credits, card.client.available_credits + card.prepay_card.credits)  
    redirect_to admin_additional_cards_path, notice: 'Tarjeta ha sido activada'
  end

  filter :status, as: :select, include_blank: false, collection: [["Activo", 1], ["Inactivo", 0]]
  filter :client_id, as: :select, collection: Client.all.map{|u| [u.business_name, u.id]}
  filter :contract_id, as: :select, collection: Contract.all.map{|u| [u.contract_number, u.id]}
  filter :prepay_card_id, as: :select, collection: PrepayCard.all.collect {|u| [u.name, u.id]}

  controller do
    # Metodo: Forma correcta de modificar el crear en el recurso de active admin 
    def create
      card = AdditionalCard.new(permitted_params[:additional_card]) 
      if card.save
        contrato = Contract.find(card.contract_id)
        contrato.update_attribute(:date_end_addition, card.end_date)
        redirect_to admin_additional_cards_path
      else
        super do |format|
          redirect_to collection_url and return if resource.valid?
        end
      end
    end  
  end
end