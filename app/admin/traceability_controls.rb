ActiveAdmin.register TraceabilityControl do

  menu false
  actions :all, except: [:show, :new, :edit, :destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 14-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla trazabilidad
  index do
    column :id
    column :doctor_id do |c|
      c.doctor_control.nil? ? 'N/A' : c.doctor_control.name.to_s + ' ' + c.doctor_control.surnames.to_s
    end
    column 'Estado' do |c|
    	case c.status
        when 1
          'Resuelto'
        when 2
          'Requerimiento'
        when 3
          'Pendiente'
        when 4
          'Archivado'
        when 5
          'En proceso'
        when 6
          'Sin créditos'
        when 7
          'Remisión'
        when 8
          'Evaluando'
        else
          'Sin enviar'
        end
    end
    column 'IPS' do |c|
      c.doctor_id.nil? ? 'N/A' : UserClient.find_by(user_id: c.doctor_id).client.business_name
    end
    column :consultation_control_id do |c|
      link_to("##{c.consultation_control_id}", admin_consultation_control_path(c.consultation_control_id))
    end
    column 'Consulta resuelta por' do |c|
      c.user_id.nil? ? 'N/A' : c.user.name.to_s + ' ' + c.user.surnames.to_s
    end
    column :assign_control_id do |c|
      c.assign_control_id.nil? ? 'N/A' : c.assign_control.name.to_s + ' ' + c.assign_control.surnames.to_s
    end
    column :reassign_control_id do |c|
      c.reassign_control_id.nil? ? 'N/A' : c.reassign_control.name.to_s + ' ' + c.reassign_control.surnames.to_s
    end
    column :seach_patient_id do |c|
      c.seach_patient_id.nil? ? 'N/A' : c.seach_patient_control.name.to_s + ' ' + c.seach_patient_control.second_name.to_s + ' ' + c.seach_patient.last_name.to_s + ' ' + c.seach_patient.second_surname.to_s
    end
    column :client_user_id do |c|
      c.client_user_id.nil? ? 'N/A' : c.client_user.name.to_s + ' ' + c.client_user.surnames.to_s
    end
    column :shared_clinic_history do |c|
      c.shared_clinic_history? ? 'Sí' : 'No'
    end
    column :print_clinic_history do |c|
      c.print_clinic_history? ? 'Sí' : 'No'
    end
    column :response_req_id do |c|
      c.response_req_id.nil? ? 'N/A' : c.response_req_control.name.to_s + ' ' + c.response_req_control.surnames.to_s
    end
    column :reject_req_id do |c|
      c.reject_req_id.nil? ? 'N/A' : c.reject_req_control.name.to_s + ' ' + c.reject_req_control.surnames.to_s
    end
    column :view_control_id do |c|
      c.view_control_id.nil? ? 'N/A' : c.view_control.name.to_s + ' ' + c.view_control.surnames.to_s
    end
    column :patient_specialist_id do |c|
      c.patient_specialist_id.nil? ? 'N/A' : c.patient_specialist_control.name.to_s + ' ' + c.patient_specialist_control.surnames.to_s
    end
    column :created_at
    column :updated_at
  end
  
  filter :doctor_id, as: :select, collection: User.where(type_professional: User::MEDICO).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :user_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :assign_control_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :reassign_control_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :created_at

  controller do
    #Metodo que filtra las trazabilidades por control
    def scoped_collection
      super.where(consultation_control_id: params[:id])
    end
  end

end
