ActiveAdmin.register Contact do
actions :all, :except => [:new, :edit, :destroy]
menu priority: 12

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-02-2019
  #
  # Autor actualizacion: Orlando Guzman Londono
  #
  # Fecha actualizacion: 04-09-2019
  #
  # Metodo: Muestra los campos de la tabla contacto
  index do
    column :id
    column :name_complete
    column :email
    column :phone
    column :message
    column :type_contact do |h|
      if h.type_contact == Contact::SOPORTE
        var = "Soporte técnico"
      else
        var = "Ventas"
      end
    end
    column 'Fecha envío' do |h|
      h.created_at.strftime("%d-%m-%Y %I:%m%P")
    end
    column 'Fecha respuesta' do |h|
      h.updated_at.strftime("%d-%m-%Y %I:%m%P")
    end
    column 'Tiempo respuesta en horas' do |c|
      if c.status == Contact::RESUELTO
        ((c.updated_at.strftime("%d/%m/%Y %I:%M%p").to_time - c.created_at.strftime("%d/%m/%Y %I:%M%p").to_time) / 3600).to_i
      else
        'N/A'
      end
    end
    column :status do |h|
      if h.status == Contact::RESUELTO
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
        var = "Resuelto"
      end
      elsif h.status == Contact::PENDIENTE
        if Date.today == h.updated_at.to_date && Time.now <= h.updated_at + 6.hour
          span :class => "", :style => " border:none; background-color: #337ab7; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
            var = "Pendiente"
          end
        elsif Date.today == h.updated_at.to_date && Time.now <= h.updated_at + 12.hour
          span :class => "", :style => " border:none; background-color: orange; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
            var = "Pendiente"
          end
        else
          span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
            var = "Pendiente"
          end
        end
      else
        span :class => "", :style => " border:none; background-color: orange; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
          var = "Evaluando"
        end
      end
    end
    actions defaults: true, name: 'Acciones' do |desk|
      if current_admin_user.role == AdminUser::SOPORTE_TECNICO
        if desk.status == Contact::EVALUANDO
          item(desk.admin_user_id.nil? ? 'Asignar' : 'Reasignar', assign_contact_admin_contacts_path(id: desk), method: :get, class: "member_link")
          item('Responder', response_form_admin_contacts_path(id: desk), method: :get, class: "member_link")
        elsif desk.status == Contact::PENDIENTE
          item(desk.admin_user_id.nil? ? 'Asignar' : 'Reasignar', assign_contact_admin_contacts_path(id: desk), method: :get, class: "member_link")
        end
      end
    end
  end

  #Analisis de respuesta a los contactos
  sidebar 'Análisis', only: :index do
    span do 
      h4 "Tiempo total en horas:",style: "display: inline"
      b "#{$total}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
      br
      h4 "Tiempo promedio en horas:",style: "display: inline"
      b "#{$count}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
    end

    ul do
      li "0 a 8 horas: #{$tmp1.nil? ? '0%' : $tmp1.to_s+'%'}"
      li "9 a 24 horas: #{$tmp2.nil? ? '0%' : $tmp2.to_s+'%'}"
      li "25 a 72 horas: #{$tmp3.nil? ? '0%' : $tmp3.to_s+'%'}"
      li "73 a 120 horas: #{$tmp4.nil? ? '0%' : $tmp4.to_s+'%'}"
      li "> a 121 horas: #{$tmp5.nil? ? '0%' : $tmp5.to_s+'%'}"
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Vista que permite asignar un administrador al contacto
  collection_action :assign_contact, method: :get do
    @page_title = "Asignar contacto"
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Vista con el formulario de responder contacto
  collection_action :response_form, method: :get do
    @page_title = "Responder contacto"
    @contact = Contact.find(params[:id])
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 12-06-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Boton Ver
  show do |h|
    attributes_table do
      row :id
      row :name_complete
      row :email
      row :phone
      row :message
      row :type_contact do |h|
        if h.type_contact == Contact::SOPORTE
          var = "Soporte técnico"
        else
          var = "Ventas"
        end
      end
      row :response_contact
      row :admin_user_id do |h|
        h.admin_user_id.nil? ? 'N/A' : h.admin_user.name.to_s + ' ' + h.admin_user.surnames.to_s
      end
      row 'Fecha envío' do |h|
        h.created_at.strftime("%d-%m-%Y %I:%m%P")
      end
      row 'Fecha respuesta' do |h|
        h.updated_at.strftime("%d-%m-%Y %I:%m%P")
      end
      row :status do |h|
        if h.status == Contact::RESUELTO
          span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
          var = "Resuelto"
        end
        elsif h.status == Contact::PENDIENTE
          if Date.today == h.updated_at.to_date && Time.now <= h.updated_at + 6.hour
            span :class => "", :style => " border:none; background-color: #337ab7; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          elsif Date.today == h.updated_at.to_date && Time.now <= h.updated_at + 12.hour
            span :class => "", :style => " border:none; background-color: orange; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          else
            span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          end
        else
          span :class => "", :style => " border:none; background-color: orange; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
            var = "Evaluando"
          end
        end
      end
    end
  end

  filter :type_contact, as: :select, collection: [['Ventas', 1], ['Soporte Técnico', 2]]
  filter :status, as: :select, collection: [['Pendiente', 1], ['Evaluando', 2], ['Resuelto', 3]]
  filter :admin_user_id, :as => :select, collection: AdminUser.all.map{ |adm| [adm.name.to_s + ' ' + adm.surnames.to_s, adm.id] }
  filter :created_at

  controller do

    def index
      super
      result,a,b,f,d,e,temp1,temp2,temp3,temp4,temp5,info = 0, [], [], [], [], [], 0, 0, 0, 0, 0, @collection_before_scope
      info.each do |c|
        if params[:q] != nil
          if c.status == Contact::RESUELTO
            if c.type_contact == params[:q][:type_contact_eq].to_i || c.status == params[:q][:status_eq].to_i || c.admin_user_id == params[:q][:admin_user_id_eq].to_i || (params[:q][:created_at_gteq_datetime].nil? ? params[:q][:created_at_lteq_datetime].to_date.beginning_of_year : c.created_at.to_date >= params[:q][:created_at_gteq_datetime].to_date && params[:q][:created_at_lteq_datetime].nil? ? params[:q][:created_at_gteq_datetime].to_date.end_of_year : c.created_at.to_date <= params[:q][:created_at_lteq_datetime].to_date) 
              hora = ((c.updated_at.strftime("%d/%m/%Y %I:%M%p").to_time - c.created_at.strftime("%d/%m/%Y %I:%M%p").to_time) / 3600).to_i
              if hora >= 0 && hora <= 8
                temp1 = a.push(hora).count
              elsif hora >= 9 && hora <= 24
                temp2 = b.push(hora).count
              elsif hora >= 25 && hora <= 72
                temp3 = f.push(hora).count
              elsif hora >= 73 && hora <= 120
                temp4 = d.push(hora).count
              elsif hora >= 121
                temp5 = e.push(hora).count
              end
              result += hora  
            end
          end
        else
          if c.status == Contact::RESUELTO 
            hora = ((c.updated_at.strftime("%d/%m/%Y %I:%M%p").to_time - c.created_at.strftime("%d/%m/%Y %I:%M%p").to_time) / 3600).to_i
            if hora >= 0 && hora <= 8
              temp1 = a.push(hora).count
            elsif hora >= 9 && hora <= 24
              temp2 = b.push(hora).count
            elsif hora >= 25 && hora <= 72
              temp3 = f.push(hora).count
            elsif hora >= 73 && hora <= 120
              temp4 = d.push(hora).count
            elsif hora >= 121
              temp5 = e.push(hora).count
            end
            result += hora
          end
        end 
      end
      
      $total = result
      $count = info.count == 0 ? 0 : ($total / info.count).to_i
      num_consult = temp1 + temp2 + temp3 + temp4 + temp5
      $tmp1 = temp1 == 0 ? 0 : ((temp1.to_f * 100) / num_consult).round #18
      $tmp2 = temp2 == 0 ? 0 : ((temp2.to_f * 100) / num_consult).round #2
      $tmp3 = temp3 == 0 ? 0 : ((temp3.to_f * 100) / num_consult).round #0
      $tmp4 = temp4 == 0 ? 0 : ((temp4.to_f * 100) / num_consult).round #1
      $tmp5 = temp5 == 0 ? 0 : ((temp5.to_f * 100) / num_consult).round #6
    end

    #Metodo que filtra mis tickets asignados
    def scoped_collection
      if current_admin_user.role == AdminUser::SUPER_ADMIN
        super.all
      else
        super.where(admin_user_id: [nil, current_admin_user.id])
      end
    end
  end
end
