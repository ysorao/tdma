ActiveAdmin.register PrepayCard do

permit_params :name, :description, :credits, :action, :admin
menu priority: 10

# Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 21-09-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla prepay_card
  index do
    column :id
    column :name
    column :description
    column :credits
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
    f.inputs 'Tarjeta de prepago' do
      f.input :name
      f.input :description
      f.input :credits
      f.input :action, as: :hidden, :input_html => { :value => params[:action] }
      f.input :admin, as: :hidden, :input_html => { :value => current_admin_user.id }
    end
    f.actions
  end

  controller do
    #Metodo que permite eliminar una tarjeta
    def destroy
      card = PrepayCard.find(params[:id])
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, delete_prepay_card: true, name_card: card.name, credits: card.credits)
      card.destroy
      respond_to do |format|
        format.html { redirect_to admin_prepay_cards_path }
      end    
    end
  end
end
