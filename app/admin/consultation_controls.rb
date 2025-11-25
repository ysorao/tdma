ActiveAdmin.register ConsultationControl do

  actions :all, except: [:new, :edit, :destroy]

  menu priority: 5

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
    column :status do |c|
    	case c.status
        when 1
          'Resuelto'
        when 2
          'Requerimiento'
        when 3
          if Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 6.hour
            span :class => "", :style => "border:none; background-color: green; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          elsif Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 12.hour
            span :class => "", :style => "border:none; background-color: #f0ad4e; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          else
            span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Pendiente"
            end
          end
        when 4
          'Archivado'
        when 5
          'En proceso'
        when 6
          'Sin créditos'
        when 7
          'Remisión'
        when 8
          if Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 6.hour
            span :class => "", :style => "border:none; background-color: green; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Evaluando"
            end
          elsif Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 12.hour
            span :class => "", :style => "border:none; background-color: #f0ad4e; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Evaluando"
            end
          else
            span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
              var = "Evaluando"
            end
          end
        else
          'Sin enviar'
        end
    end
    column :doctor_id do |c|
      c.doctor_id.nil? ? 'No aplica' : c.doctor_control.name.to_s + ' ' + c.doctor_control.surnames.to_s
    end
    column :specialist_id do |c|
      c.specialist_id.nil? ? 'No aplica' : c.specialist_control.name.to_s + ' ' + c.specialist_control.surnames.to_s
    end
    column :ips do |c|
      if c.doctor_control.nil?
      	'No tiene'
      else
        Client.find(c.doctor_control.user_clients.first.client_id).business_name
      end
    end
    column :created_at
    column 'Respuesta el' do |c|
      if c.status == Consultation::RESUELTO || c.status == Consultation::REMISION || c.status == Consultation::REQUERIMIENTO
        c.specialist_responses.first.created_at
      else
        'N/A'
      end
    end
    column 'Tiempo respuesta en horas' do |c|
      if c.status == Consultation::RESUELTO || c.status == Consultation::REMISION
        ((c.updated_at.strftime("%d/%m/%Y %I:%M%p").to_time - c.created_at.strftime("%d/%m/%Y %I:%M%p").to_time) / 3600).to_i
      else
        'N/A'
      end
    end
    actions name: 'Acciones' do |c|
      if c.status == Consultation::PENDIENTE
        item "Asignar", assign_specialist_admin_traceability_admins_path(control_id: c.id, t: 'a'), class: "member_link"
      elsif c.status == Consultation::EVALUANDO
        item "Reasignar", assign_specialist_admin_traceability_admins_path(control_id: c.id, t: 'r'), class: "member_link"
      end
    end
    actions defaults: false, name: 'Trazabilidad' do |c|
      unless c.traceability_controls.blank?
        item "Ver", admin_traceability_controls_path(id: c)
      end
    end
  end

  sidebar 'Análisis controles', only: :index do
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
  # Fecha creacion: 14-08-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Mostrar
  show :title => 'Información' do |c|
    attributes_table do
      row :id
      row :status do |c|
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
            if Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 6.hour
              span :class => "", :style => "border:none; background-color: green; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
                var = "Evaluando"
              end
            elsif Date.today == c.updated_at.to_date && Time.now <= c.updated_at + 12.hour
              span :class => "", :style => "border:none; background-color: #f0ad4e; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
                var = "Evaluando"
              end
            else
              span :class => "", :style => "border:none; background-color: red; color: white;height:30px; padding: 5px; font-weight: bold; font-size: 15px;" do
                var = "Evaluando"
              end
            end
          else
            'Sin enviar'
          end
      end
      row :doctor_id do |c|
      	c.doctor_id.nil? ? 'No aplica' : c.doctor_control.name.to_s + ' ' + c.doctor_control.surnames.to_s
	    end
	    row :specialist_id do |c|
	      c.specialist_id.nil? ? 'No aplica' : c.specialist_control.name.to_s + ' ' + c.specialist_control.surnames.to_s
	    end
	    row :ips do |c|
	      cliente = c.doctor_control.nil? ? c.nurse_control.user_clients.first.client_id : c.doctor_control.user_clients.first.client_id
	      Client.find(cliente).business_name
	    end
	    row :created_at
	  end
	end
  
  filter :status, as: :select, collection: [['Resuelto', 1], ['Requerimiento', 2], ['Pendiente', 3], ['Archivado', 4], ['En proceso', 5], ['Sin créditos', 6], ['Remisión', 7], ['Evaluando', 8]]
  filter :specialist_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :doctor_id, as: :select, collection: User.where(type_professional: User::MEDICO).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :vendor_in, :as => :select, :label => 'IPS', :collection => proc { Client.all.map{ |cli| [cli.business_name, cli.id] } }
  filter :created_at

  controller do

    before_action :index

    #Encargado que al momento de generar un filtro los registros se cambien
    #para calcular los valores en horas del movimiento de respuesta de los controles en sus
    #diferentes estados, fechas y especialista(s)
    def index
      super
      result,a,b,f,d,e,temp1,temp2,temp3,temp4,temp5,info = 0, [], [], [], [], [], 0, 0, 0, 0, 0, @collection_before_scope
      info.each do |c|
        if params[:q] != nil
          if c.status == Consultation::RESUELTO || c.status == Consultation::REMISION
            if (params[:q][:specialist_id_in] != nil && params[:q][:specialist_id_in].include?(c.specialist_id.to_s)) || c.status == params[:q][:status_eq].to_i || c.doctor_id == params[:q][:doctor_id_eq].to_i || (!params[:q][:created_at_gteq_datetime].nil? && !params[:q][:created_at_lteq_datetime].nil?) 
              if (!params[:q][:created_at_gteq_datetime].nil? || !params[:q][:created_at_lteq_datetime].nil?)
                if (params[:q][:created_at_gteq_datetime].nil? ? params[:q][:created_at_lteq_datetime].to_date.beginning_of_year : c.created_at.to_date >= params[:q][:created_at_gteq_datetime].to_date && params[:q][:created_at_lteq_datetime].nil? ? params[:q][:created_at_gteq_datetime].to_date.end_of_year : c.created_at.to_date <= params[:q][:created_at_lteq_datetime].to_date)
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
          if c.status == Consultation::RESUELTO || c.status == Consultation::REMISION 
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

    def scoped_collection
      super
      # if params[:commit] == 'Filtrar'
      #   super
      # else 
      #   consult = ConsultationControl.find_by(id: @_params[:id])
      #   if (consult.nil? || @_params[:page].nil?) && @_params[:q].nil?
      #     super.where(status: [Consultation::EVALUANDO, Consultation::PENDIENTE])
      #   else
      #     super
      #   end
      # end
    end
  end
end