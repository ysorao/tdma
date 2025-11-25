ActiveAdmin.register TraceabilityClient do

  menu false
  actions :all, except: [:show, :new, :edit, :destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 01-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla trazabilidad
  index do
    column :id
    column 'Cliente' do |c|
      c.client_user.client.business_name
    end
    column :client_user_id do |c|
      c.client_user_id.nil? ? 'No aplica' : c.client_user.name.to_s + ' ' + c.client_user.surnames.to_s
    end
    column :create_patient_id do |c|
      c.create_patient_id.nil? ? 'No aplica' : c.create_patient.name.to_s + ' ' +  c.create_patient.surnames.to_s
    end
    column :shared_clinic_history do |c|
      c.shared_clinic_history? ? 'Sí' : 'No'
    end
    column :print_clinic_history do |c|
      c.print_clinic_history? ? 'Sí' : 'No'
    end
    column :created_at
  end

  filter :client_user_id, as: :select, collection: ClientUser.all.collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :create_patient_id, as: :select, collection: ClientUser.all.collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :created_at

  controller do
    #Metodo que filtra solo los usuarios especialistas
    def scoped_collection
      super.where(client_user_id: params[:id])
    end
  end
end