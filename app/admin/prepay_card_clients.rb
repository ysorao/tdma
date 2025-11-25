ActiveAdmin.register PrepayCardClient do

menu false

#permit_params :purchase_date, :prepay_card_id, :contract_id, :client_id

#menu :parent => "Clientes", priority: 5

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla user
  #index do
    #column :id
    #column :purchase_date
    #column :prepay_card_id do |card|
      #card.prepay_card_id.nil? ? 'No esta asociado' : card.prepay_card.name
    #end
    #column :contract_id do |cont|
      #cont.contract_id.nil? ? 'No esta asociado' : cont.contract.contract_number
    #end
    #column :client_id do |c|
      #c.client_id.nil? ? 'No esta asociado' : c.client.business_name
    #end
    #column :created_at
    #column :updated_at
    #actions
  #end


  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: que se encarga del editar y nuevo
  #form do |f|
    #f.inputs 'Dispositivo' do
      #f.input :purchase_date, as: :datepicker, datepicker_options: {min_date: 1.month.ago.to_date, max_date: "+1Y"}, input_html: {:readonly => true}
      #f.input :prepay_card_id, as: :select, collection: PrepayCard.all.collect {|u| [u.name, u.id]}
      #f.input :contract_id, as: :select, collection: Contract.all.where(status: Contract::ACTIVO).collect {|u| [u.contract_number, u.id]}
      #f.input :client_id, as: :select, collection: Client.all.where(status: Client::ACTIVO).collect {|u| [u.business_name, u.id]}  
    #end
    #f.actions
  #end
end
