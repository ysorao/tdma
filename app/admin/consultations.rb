ActiveAdmin.register Consultation do
  
  #permit_params :annex_description, :audio_annex, :date_archived, :status, :patient_id, :patient_information_id, :specialist_id, :assistant_id, :doctor_id, :nurse_id, :assign_id, :recommended_treatment, :created_at, :updated_at

  menu priority: 4
  actions :all, except: [:new, :edit, :destroy]

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla consulta
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
    column :patient_id do |c|
      c.patient.name.to_s + ' ' + c.patient.second_name.to_s + ' ' + c.patient.last_name.to_s + ' ' + c.patient.second_surname.to_s
    end
    column :Identificación do |c|
      c.patient.number_document
    end
    column :Género do |c|
      c.patient.genre == 1 ? 'Masculino' : 'Femenino'
    end
    column :Edad do |c|
      c.patient_information.age
    end
    column :doctor_id do |c|
      c.doctor.nil? ? 'No aplica' : c.doctor.name.to_s + ' ' + c.doctor.surnames.to_s
    end
    column :specialist_id do |c|
      c.specialist.nil? ? 'No aplica' : c.specialist.name.to_s + ' ' + c.specialist.surnames.to_s
    end
    column :ips do |c|
      if c.doctor.nil? 
        'No tiene'
      else
        Client.find(c.doctor.user_clients.first.client_id).business_name
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
        item "Asignar", assign_specialist_admin_traceability_admins_path(consult_id: c.id, t: 'a'), class: "member_link"
      elsif c.status == Consultation::EVALUANDO
        item "Reasignar", assign_specialist_admin_traceability_admins_path(consult_id: c.id, t: 'r'), class: "member_link"
      end
    end
    actions defaults: false, name: 'Controles' do |c|
      unless c.consultation_controls.blank?
        item "Ver", admin_consultation_controls_path(id: c), class: "member_link"
      end
    end

    actions defaults: false, name: 'Trazabilidad' do |c|
      unless c.traceability_consults.blank?
        item "Ver", admin_traceability_consults_path(id: c)
      end
    end
  end

  sidebar 'Análisis consultas', only: :index do
    span do 
      h4 "Tiempo total en horas:",style: "display: inline"
      b "#{$total}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
      br
      h4 "Tiempo promedio en horas:",style: "display: inline"
      b "#{$count}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
      br
      h4 "Número de días promedio:",style: "display: inline"
      b "#{$count.nil? ? 0 : ($count / 24.to_f).round(1)}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
      br
      h4 "Número de días promedio laboral:",style: "display: inline"
      b "#{$count.nil? ? 0 : (($count / 24) / 3.to_f).round(1)}", "data-no-turbolink": "true", style: "display: inline; font-size: 13px;"
    end

    ul do
      li "0 a 8 horas: #{$tmp1.nil? ? '0%' : $tmp1.to_s+'%'}"
      li "9 a 24 horas: #{$tmp2.nil? ? '0%' : $tmp2.to_s+'%'}"
      li "25 a 72 horas: #{$tmp3.nil? ? '0%' : $tmp3.to_s+'%'}"
      li "73 a 120 horas: #{$tmp4.nil? ? '0%' : $tmp4.to_s+'%'}"
      li "> a 121 horas: #{$tmp5.nil? ? '0%' : $tmp5.to_s+'%'}"
    end
  end

  sidebar 'Teleconsultas especialista. Incluye controles', only: :index do
    todo = (Consultation.where.not(specialist_id: nil) + ConsultationControl.where.not(specialist_id: nil)).group_by(&:specialist_id)        
    todo.each do |x|
      span do 
        usuario = User.find(x[0])
        h4 "#{usuario.name + ' ' + usuario.surnames}",style: "display: inline; font-weight:bold;"
      end
      a,b,c = 0,0,0
      x[1].each do |z|
        if z.status == 1
          a = a + 1
        elsif z.status == 2
          b = b + 1
        elsif z.status == 7
          c = c + 1
        end
      end
      ul do  
        li "Resueltas: #{a}"
        li "Requerimiento: #{b}"
        li "Remisión: #{c}"    
      end
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 10-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Vista del los indicadores
  collection_action :indicators, method: :get do
    @page_title = "Indicadores"
    #Permite mostrar los 10 primeros diagnosticos de todas las consultas
    order_diseases, w = OtherDiagnostic.order_diagnostics, []
    order_diseases.each {|x| w.push({name: x[0], cuenta: x[1].count})}
    cuenta = w.sort_by {|z| z[:cuenta]}.group_by { |d| d[:cuenta] }
    @orden = cuenta.map {|w| w[1].sort_by!{|y| y[:cuenta]}}.reverse.flatten
    
    #Permite mostrar las consultas por el buscador de patologias
    if params[:search].nil?
      consultation = Consultation.all.order(created_at: :desc)
      controles = ConsultationControl.all.order(created_at: :desc)
      aux = []
      consultation.map {|x| aux.push({consulta: x, controles: [x.consultation_controls.order(created_at: :desc)]})}
      @consultation = [aux, (consultation.count + controles.count)]
      $global_total = @consultation[1]
    else
      @teleconsultas = Consultation.search_consults_disease(params[:search])
      enferm = Disease.find_by(name: params[:search])
      @disease = enferm.nil? ? 'N/A' : enferm.name
    end

    #Permite mostrar los 10 primeros diagnosticos pero con filtros
    if (params[:municipality].nil? && params[:age].nil? && params[:genre].nil? && params[:urban_zone].nil? && params[:type_user].nil? && params[:especialista].nil? && params[:age1].nil? && params[:age2].nil?)
      @results = nil
    else
      order_diagnostics, h = OtherDiagnostic.filter_diagnostics(params[:municipality], params[:age], (params[:age1]..params[:age2]), params[:genre], params[:urban_zone], params[:type_user], params[:especialista]), []

      order_diagnostics.each {|a| h.push({name: a[0], cuenta: a[1].count})}
      cuenta = h.sort_by {|b| b[:cuenta]}.group_by { |c| c[:cuenta] }
      @orden_diag = cuenta.map {|d| d[1].sort_by!{|e| e[:cuenta]}}.reverse.flatten
    end

    #Permite mostrar el total de consultas segun el especialista y el estado
    @resueltas = Consultation.where(status: Consultation::RESUELTO)
    g, h, i = 0, 0, 0
    @resueltas.map {|q| g = g + q.consultation_controls.where(status: Consultation::RESUELTO).count}
    @result_res = @resueltas.count + g
    @req = Consultation.where(status: Consultation::REQUERIMIENTO)
    @req.map {|t| h = h + t.consultation_controls.where(status: Consultation::REQUERIMIENTO).count}
    @result_req = @req.count + h
    @remision = Consultation.where(status: Consultation::REMISION)
    @remision.map {|c| i = i + c.consultation_controls.where(status: Consultation::REMISION).count}
    @result_rem = @remision.count + i
    
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 24-07-2018
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
            'Evaluando'
          else
            'Sin enviar'
          end
      end
      row :patient_id do |c|
        c.patient.name.to_s + ' ' + c.patient.second_name.to_s + ' ' + c.patient.last_name.to_s + ' ' + c.patient.second_surname.to_s
      end
      row :Identificación do |c|
        c.patient.number_document
      end
      row :Género do |c|
        c.patient.genre == 1 ? 'Masculino' : 'Femenino'
      end
      row :doctor_id do |c|
        c.doctor.nil? ? 'No aplica' : c.doctor.name.to_s + ' ' + c.doctor.surnames.to_s
      end
      row :specialist_id do |c|
        c.specialist.nil? ? 'No aplica' : c.specialist.name.to_s + ' ' + c.specialist.surnames.to_s
      end
      row :created_at
      row :updated_at
    end
  end

  filter :status, as: :select, collection: [['Resuelto', 1], ['Requerimiento', 2], ['Remisión', 7], ['Pendiente', 3], ['Archivado', 4], ['En proceso', 5], ['Sin créditos', 6], ['Evaluando', 8]]
  filter :specialist_id, as: :select, collection: User.where(type_professional: User::ESPECIALISTA).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}, input_html: { id: "filter_specialist", multiple: true, class:"chosen-select", 'data-placeholder': "Seleccione" }
  filter :doctor_id, as: :select, collection: User.where(type_professional: User::MEDICO).collect {|u| [u.name.to_s + ' ' + u.surnames.to_s, u.id]}
  filter :vendor_in, :as => :select, :label => 'IPS', :collection => proc { Client.all.map{ |cli| [cli.business_name, cli.id] } }
  filter :created_at

  controller do

    #before_action :index

    #Encargado que al momento de generar un filtro los registros se cambien
    #para calcular los valores en horas del movimiento de respuesta de las consultas en sus
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
  
    #Metodo que filtra las consultas por estado evaluando
    def scoped_collection
      if params[:commit] == 'Filtrar'
        super
      else
        consult = Consultation.find_by(id: @_params[:id])
        if (consult.nil? || @_params[:page].nil?) && @_params[:q].nil?
          super.where(status: [Consultation::EVALUANDO, Consultation::PENDIENTE])
        else
          super
        end
      end
    end
  end
end
