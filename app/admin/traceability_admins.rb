ActiveAdmin.register TraceabilityAdmin do

  menu false
  actions :all, :except => [:show, :new, :edit, :destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 29-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla trazabilidad admin
  index do
    admin = AdminUser.find(params[:id]).role
    if admin == AdminUser::SUPER_ADMIN
      column :id
      column :admin_user_id do |c|
        c.admin_user.name.to_s + ' ' + c.admin_user.surnames.to_s
      end
      column :rol do |c|
        if c.rol == AdminUser::SUPER_ADMIN
          'Super administrador'
        elsif c.rol == AdminUser::ADMIN
          'Administrador'
        else
          'Soporte tecnico'
        end
      end
      column :create_admin do |c|
        if c.create_admin?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_admin
      column :activate_admin
      column :desactivate_admin
      column :delete_admin do |c|
        if c.delete_admin?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :name_complete_admin
      column :document_admin
      column :rol do |c|
        if c.user_admin.nil?
          'N/A'
        elsif c.user_admin.role == AdminUser::SUPER_ADMIN
          'Super administrador'
        elsif c.user_admin.role == AdminUser::ADMIN
          'Administrador'
        else
          'Soporte tecnico'
        end
      end
      column :user_admin_id do |c|
        c.user_admin.nil? ? 'N/A' : c.user_admin.name.to_s + ' ' + c.user_admin.surnames.to_s
      end
      column :create_user do |c|
        if c.create_user?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :activate_user
      column :desactivate_user
      column :delete_user do |c|
        if c.delete_user?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :name_complete_user
      column :document_user
      column :patients_attended do |c|
        if c.patients_attended.nil?
          0
        else
          c.user_id.nil? ? 0 : User.attended(c.user_id)
        end
      end
      column :user_id do |c|
        c.user_id.nil? ? 'N/A' : c.user.name.to_s + ' ' + c.user.surnames.to_s
      end
      column :create_client do |c|
        if c.create_client?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_client
      column :activate_client
      column :desactivate_client
      column :client_id do |c|
        c.client_id.nil? ? 'N/A' : c.client.business_name
      end
      column :create_user_client do |c|
        if c.create_user_client?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_user_client
      column :client_user_id do |c|
        c.client_user_id.nil? ? 'N/A' : c.client_user.name.to_s + ' ' + c.client_user.surnames.to_s
      end
      column :create_contract do |c|
        if c.create_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :delete_contract do |c|
        if c.delete_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :contract_number
      column :date_init do |c|
        c.date_init.nil? ? 'N/A' : c.date_init.strftime("%d-%m-%Y %I:%m%P")
      end
      column :date_end do |c|
        c.date_end.nil? ? 'N/A' : c.date_end.strftime("%d-%m-%Y %I:%m%P")
      end
      column :contract_id do |c|
        c.contract_id.nil? ? 'N/A' : c.contract.contract_number
      end
      column :create_bill do |c|
        if c.create_bill?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_bill
      column :delete_bill do |c|
        if c.delete_bill?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :code_bill
      column :date_expedition do |c|
        c.date_expedition.nil? ? 'N/A' : c.date_expedition.strftime("%d-%m-%Y %I:%m%P")
      end
      column :bill_id do |c|
        c.bill_id.nil? ? 'N/A' : c.bill.code
      end
      column :create_addition_contract do |c|
        if c.create_addition_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :additional_card_id
      column :create_kit do |c|
        if c.create_kit?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :delete_kit do |c|
        if c.delete_kit?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :code_kit
      column :is_comodato do |c|
        if c.is_comodato?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :kit_id do |c|
        c.kit_id.nil? ? 'N/A' : c.kit.code
      end
      column :create_device do |c|
        if c.create_device?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_device
      column :delete_device do |c|
        if c.delete_device?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :imei
      column :device_id do |c|
        c.device_id.nil? ? 'N/A' : c.device.imei
      end
      column :create_manual_system do |c|
        if c.create_manual_system?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_manual_system
      column :delete_manual_system do |c|
        if c.delete_manual_system?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :name_manual
      column :system_manual_id do |c|
        c.system_manual_id.nil? ? 'N/A' : c.system_manual.name
      end
      column :create_prepay_card do |c|
        if c.create_prepay_card?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_prepay_card
      column :delete_prepay_card do |c|
        if c.delete_prepay_card?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :name_card
      column :credits
      column :prepay_card_id do |c|
        c.prepay_card_id.nil? ? 'N/A' : c.prepay_card.name
      end
      column :create_version do |c|
        if c.create_version?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_version
      column :delete_version do |c|
        if c.delete_version?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :file_name
      column :app_version_id do |c|
        c.app_version_id.nil? ? 'N/A' : c.app_version.version_movil
      end
      column :consultation_id do |c|
        c.consultation.nil? ? 'No aplica' : c.consultation.id
      end
      column :assign_consult_id do |c|
        c.assign_consult.nil? ? 'No aplica' : c.assign_consult.name.to_s + ' ' + c.assign_consult.surnames.to_s
      end
      column :reassign_consult_id do |c|
        c.reassign_consult.nil? ? 'No aplica' : c.reassign_consult.name.to_s + ' ' + c.reassign_consult.surnames.to_s
      end
      column :consultation_control_id do |c|
        c.consultation_control.nil? ? 'No aplica' : c.consultation_control.id
      end
      column :assign_control_id do |c|
        c.assign_control.nil? ? 'No aplica' : c.assign_control.name.to_s + ' ' + c.assign_control.surnames.to_s
      end
      column :reassign_control_id do |c|
        c.reassign_control.nil? ? 'No aplica' : c.reassign_control.name.to_s + ' ' + c.reassign_control.surnames.to_s
      end
    elsif admin == AdminUser::ADMIN
      column :id
      column :create_client do |c|
        if c.create_client?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_client
      column :activate_client
      column :desactivate_client
      column :client_id do |c|
        c.client_id.nil? ? 'N/A' : c.client.business_name
      end
      column :create_user_client do |c|
        if c.create_user_client?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_user_client
      column :client_user_id do |c|
        c.client_user_id.nil? ? 'N/A' : c.client_user.name.to_s + c.client_user.surnames.to_s
      end
      column :create_contract do |c|
        if c.create_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :delete_contract do |c|
        if c.delete_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :contract_number
      column :date_init do |c|
        c.date_init.nil? ? 'N/A' : c.date_init.strftime("%d-%m-%Y %I:%m%P")
      end
      column :date_end do |c|
        c.date_end.nil? ? 'N/A' : c.date_end.strftime("%d-%m-%Y %I:%m%P")
      end
      column :contract_id do |c|
        c.contract_id.nil? ? 'N/A' : c.contract.contract_number
      end
      column :create_bill do |c|
        if c.create_bill?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_bill
      column :delete_bill do |c|
        if c.delete_bill?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :code_bill
      column :date_expedition do |c|
        c.date_expedition.nil? ? 'N/A' : c.date_expedition.strftime("%d-%m-%Y %I:%m%P")
      end
      column :bill_id do |c|
        c.bill_id.nil? ? 'N/A' : c.bill.code
      end
      column :create_addition_contract do |c|
        if c.create_addition_contract?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :additional_card_id
      column :create_kit do |c|
        if c.create_kit?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :delete_kit do |c|
        if c.delete_kit?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :code_kit
      column :is_comodato do |c|
        if c.is_comodato?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :kit_id do |c|
        c.kit_id.nil? ? 'N/A' : c.kit.code
      end
      column :create_device do |c|
        if c.create_device?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :update_device
      column :delete_device do |c|
        if c.delete_device?
          span :class => "status_tag yes" do
            var = "Sí"
          end
        else
          span :class => "status_tag no" do
            var = "No"
          end
        end
      end
      column :imei
      column :device_id do |c|
        c.device_id.nil? ? 'N/A' : c.device.imei
      end
    elsif admin == AdminUser::SOPORTE_TECNICO
      column :id
      column :assign_contact
      column :response_contact
      column :contact_id do |c|
        c.contact_id.nil? ? 'N/A' : c.contact.email
      end
      column :assign_help_desk
      column :response_help_desk
      column :help_desk_id do |c|
        c.help_desk_id.nil? ? 'N/A' : c.help_desk.ticket
      end
    end
      column :created_at
      column :updated_at
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 17-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Vista que permite asignar o reasignar un especialista
  collection_action :assign_specialist, method: :get do
    @page_title = "Asignar"
  end

  filter :admin_user_id, as: :select, :collection => (AdminUser.all.map{|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]})

  controller do
    #Metodo que filtra las trazabilidades del admin
    def scoped_collection
      super.where(admin_user_id: params[:id])
    end
  end
end