class Api::V1::ConsultationsController < ApiController

  skip_before_action :verify_authenticity_token

  include ProofGlobalModule

  respond_to :json


  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-29
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista de consultas por estado y medico
  #
  # URL: /api/v1/consultations.json
  def index
    if params[:status].reject(&:empty?).blank? || params[:number_document].blank?
      render status: 411, json: {error: "El estado o el número de documento no pueden estar vacíos"}  
    end
    user = User.find_by_number_document(params[:number_document])
    if user.type_professional == User::MEDICO
      if params[:status][0].to_i == 4
        @patient_consults = Patient.includes(consultations: :doctor).where("consultations.archived = ? AND users.number_document = ?", true, params[:number_document].to_s).order(created_at: :desc).references(consultations: :doctor)
      else
        @patient_consults = Patient.includes(consultations: :doctor).where("consultations.status IN (?) AND consultations.archived = ? AND users.number_document = ?", params[:status], false, params[:number_document].to_s).order(created_at: :desc).references(consultations: :doctor)
      end
    elsif user.type_professional == User::ENFERMERA
      if params[:status][0].to_i == 4
        @patient_consults = Patient.includes(consultations: :nurse).where("consultations.archived = ? AND users.number_document = ?", true, params[:number_document].to_s).order(created_at: :desc).references(consultations: :nurse)
      else
        @patient_consults = Patient.includes(consultations: :nurse).where("consultations.status IN (?) AND consultations.archived = ? AND users.number_document = ?", params[:status], false, params[:number_document].to_s).order(created_at: :desc).references(consultations: :nurse)
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-08-29
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista de consultas por estado y medico
  #
  # URL: /api/v1/consultations/all_information.json
  def all_information
    if params[:status].reject(&:empty?).blank? || params[:number_document].blank?
      render status: 411, json: {error: "El estado o el número de documento no pueden estar vacíos"}  
    else
      user = User.find_by_number_document(params[:number_document])
      if user.type_professional == User::MEDICO
        #if params[:status][0].to_i == 4
          #@patient = Patient.consult(params[:number_document])
        #else
        @patient = Patient.control(params[:status], params[:number_document])
        #end
      end 
    end 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-24
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista la consulta o control con su informacion general
  #
  # URL: /api/v1/consultations/show_information.json
  def show_information
    if params[:consultation_id].blank? && params[:consultation_control_id].blank?
      render status: 411, json: {error: 'Consulta o control no pueden estar vacíos'}
    elsif !Consultation.exists?(params[:consultation_id]) && !ConsultationControl.exists?(params[:consultation_control_id])
      render status: 411, json: {error: 'Consulta o control no existe'}
    else
      if params[:consultation_control_id].blank?
        @patient_information = Patient.includes(:consultations).where("consultations.id = ?", params[:consultation_id]).references(:consultations).first  
      else
        @patient_information = Patient.includes(:consultation_controls).where("consultation_controls.id = ?", params[:consultation_control_id]).references(:consultation_controls).first 
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-21
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear consulta para el medico
  #
  # URL: /api/v1/consultations.json
  def create
    consulta = Consultation.new(consultant_params)
    consulta.usuario = params[:user_token]

    #if request.headers["imei"].blank?
      #render status: 411, json: {error: "El imei no puede estar vacío"}
    #else
      #unless validate_imei(request.headers["imei"], current_user).nil?
        if consulta.save
          #Verifica si tiene creditos la IPS
          card = Client.enabled_credits(current_user)
          if card.first.available_credits == 0
            consulta.update(status: Consultation::SIN_CREDITOS, updated_at: Time.now)
            consulta.patient_information.update_attribute(:status, Consultation::SIN_CREDITOS)
            NotificationCreditsWorker.perform_async(card.first.id)
          else
            card.first.update_attribute(:available_credits, (card.first.available_credits - 1))

            #Verifica si alguna consulta sigue en estado requerimiento o pendiente
            estados_paciente = Consultation.consult_status(consulta.patient_id)
            requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}

            if requirement.nil?
              consulta.patient.patient_informations.last.update_attribute(:status, Consultation::PENDIENTE)
            else
              consulta.patient.patient_informations.last.update_attribute(:status, Consultation::REQUERIMIENTO)
            end  
          end
          medical_consulta = MedicalConsultation.new(medical_consultant_params)

          if medical_consulta.save
            medical_consulta.update_attribute(:consultation_id, consulta.id)
            TraceabilityConsult.create(doctor_id: consulta.doctor_id, consultation_id: consulta.id, status: consulta.status)
            puts "=======> consulta #{consulta.inspect}"
            render status: 200, json: {status: 200, consultant: consulta, medical_consultant: medical_consulta, message: "Se ha guardado correctamente."}
          else
            puts "=======> medical_consultation #{medical_consulta.errors.inspect}"
            render status: 411, json: {error: 'No se guardo la consulta del paciente', medical_consultant: medical_consulta.errors}
          end
        else
          puts "=======> consultation #{consulta.errors.inspect}"
          render status: 411, json: {error: 'No se guardo la consulta del paciente', consultant: consulta.errors}
        end
      #else
        #puts "=======> Imei o contrato #{el imei no le pertenece al cliente o el contrato ha expirado}"
        #render status: 411, json: {error: "El imei no le pertenece al cliente o el contrato ha expirado"}
      #end
    #end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-27
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear imagenes anexas de la consulta o el control
  #
  # URL: /api/v1/consultations/update.json
  def update
    annex_image = ''
    if params[:consultation_id].blank? && params[:consultation_control_id].blank?
      render status: 411, json: {error: 'Consulta o control debe estar lleno'}
    else
      if params[:images_annex].reject(&:empty?).blank?
        render status: 411, json: {error: 'Al menos una imagen es obligatoria'}
      else
        imagenes = AnnexImage.where(consultation_id: nil, consultation_control_id: nil)
        params[:images_annex].each do |im|
          imagenes.each do |x|
            if im.split("/").last == x.annex_url.url.split("/").last
              x.update_attribute(:consultation_id, params[:consultation_id])
              x.update_attribute(:consultation_control_id, params[:consultation_control_id])
            end
          end
        end
        render status: 200, json: { consultation_id: params[:consultation_id], consultation_control_id: params[:consultation_control_id], message: "Se ha guardado correctamente."}
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Archivar y desarchivar consulta
  #
  # URL: /api/v1/consultations/archived_consultation.json
  def archived_consultation
    if params[:tipo].blank? || params[:id].blank?
      render status: 411, json: {error: 'No puede estar vacío'}
    else
      if Consultation.exists?(params[:id])
        archivar = Consultation.find(params[:id])
        if params[:tipo].to_i == 1
          consultas = Consultation.where(patient_id: archivar.patient_id, status: [Consultation::RESUELTO, Consultation::REMISION])
          consultas.update_all(archived: true, status: Consultation::ARCHIVADO)
          render status: 200, json: {status: 200, message: "Ha sido archivado."}  
        elsif params[:tipo].to_i == 2
          consulta2 = Consultation.where(patient_id: archivar.patient_id, status: Consultation::ARCHIVADO)
          puts "#{consulta2.count.inspect}"
          consulta2.each do |estado|
            estado_final = TraceabilityConsult.where(consultation_id: estado.id, status: [Consultation::RESUELTO, Consultation::REMISION]).order(:id).last
            puts "aaaaaaaa #{estado_final.inspect}"
            estado.update_attribute(:archived, false)
            estado.update_attribute(:status, estado_final.status)
          end
          render status: 200, json: {status: 200, consultation_status: archivar.status, message: "Ha sido desarchivado."}
        end
      else
        render status: 411, json: {error: 'No existe la consulta.'}
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: Post
  #
  # Metodo: Compartir consulta(s) y enviarlas al correo del paciente
  #
  # URL: /api/v1/consultations/shared_consultations.json
  def shared_consultations
    if params[:consult_ids].reject(&:empty?).blank?
      render status: 411, json: {error: 'Debe añadir al menos una consulta'}
    else
      consulta = Consultation.where(id: params[:consult_ids])
      email = ""

      consulta.each do |consul|
        #Trazabilidad
        TraceabilityConsult.create(
            doctor_id: consul.doctor_id, 
            consultation_id: consul.id, 
            shared_clinic_history: true, 
            status: consul.status
        )
        if !consul.patient_information.email.nil?
          email = consul.patient_information.email
        end
      end
      
      #PatientConsultsWorker.perform_async(email)
      if email.blank?
        render status: 200, json: {message: 'El correo no se encuentra registrado, dirijase al modulo de administración para la impresión de su historia clínica.'}
      else
        EmailDocumentation.patient_consults(consulta, email).deliver_now
        render status: 200, json: {message: 'Enviado(s) correctamente!'}
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Resolver requerimiento que pidio el especialista
  #
  # URL: /api/v1/consultations/response_request.json
  def response_request
    if Request.exists?(params[:id])
      requests = Request.find(params[:id])
      #if params[:images].reject(&:empty?).blank? && params[:request][:audio_request].blank? && params[:request][:description_request].blank?
        #render status: 411, json: {error: 'Al menos una es obligatoria'}  
      #else
      if request.headers["imei"].blank?
        render status: 411, json: {error: "El imei no puede estar vacío"}
      else
        unless validate_imei(request.headers["imei"], current_user).nil?
          if requests.update(request_params)
            profesional = User.find_by_authentication_token(params[:user_token])
            if profesional.type_professional == User::MEDICO
              requests.update_attribute(:doctor_id, profesional.id)
            elsif profesional.type_professional == User::ENFERMERA
              requests.update_attribute(:nurse_id, profesional.id)
            end
            if requests.consultation_id.nil?
              requests.consultation_control.update_attribute(:status, Consultation::PENDIENTE)
              requests.consultation_control.update_attribute(:updated_at, Time.now)
              #Trazabilidad
              TraceabilityControl.create(doctor_id: profesional.id, response_req_id: profesional.id, consultation_control_id: requests.consultation_control.id, status: requests.consultation_control.status)
            else  
              requests.consultation.update_attribute(:status, Consultation::PENDIENTE)
              requests.consultation.update_attribute(:updated_at, Time.now)
              #Trazabilidad
              TraceabilityConsult.create(doctor_id: profesional.id, response_req_id: profesional.id, consultation_id: requests.consultation.id, status: requests.consultation.status)
            end
            render status: 200, json: {status: 200, request: requests, message: "Se ha guardado correctamente."}
          else
            puts "=======> request #{requests.errors.inspect}"
            render status: 411, json: {error: 'No se guardo el requerimiento', request: requests.errors}
          end
        else
          render status: 411, json: {error: "El imei no le pertenece al cliente"}
        end
      end
      #end
    else
      render status: 411, json: {error: 'No existe el requerimiento.'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-03-12
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Descartar requerimiento
  #
  # URL: /api/v1/consultations/reject_request.json
  def reject_request
    if Request.exists?(params[:id])
      requests = Request.find(params[:id])
      if request.headers["imei"].blank?
        render status: 411, json: {error: "El imei no puede estar vacío"}
      else
        unless validate_imei(request.headers["imei"], current_user).nil?
          if requests.update(reject_request_params)
            profesional = User.find_by_authentication_token(params[:user_token])
            if profesional.type_professional == User::MEDICO
              requests.update_attribute(:doctor_id, profesional.id)
            elsif profesional.type_professional == User::ENFERMERA
              requests.update_attribute(:nurse_id, profesional.id)
            end
            
            puts "aaaaaaa #{requests.inspect}"

            if requests.consultation_id.nil?
              status_paciente = ConsultationControl.consult_status(requests.consultation_control.patient_id)
              requirement_control = status_paciente.detect{|w| w == Consultation::REQUERIMIENTO}
              if [requirement_control].count > 1
                puts "CONSULTAAAAA #{requirement_control.inspect}"
                requests.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
                requests.consultation_control.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
                requests.consultation_control.consultation.update_attribute(:updated_at, Time.now)
                requests.consultation_control.update_attribute(:status, Consultation::RESUELTO)
                requests.consultation_control.update_attribute(:updated_at, Time.now)
              else
                puts "CONTROLLL #{requirement_control.inspect}"
                requests.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
                requests.consultation_control.update_attribute(:status, Consultation::RESUELTO)
                requests.consultation_control.update_attribute(:updated_at, Time.now)
                requests.consultation_control.consultation.update_attribute(:status, Consultation::RESUELTO)
                requests.consultation_control.consultation.update_attribute(:updated_at, Time.now)
                #Trazabilidad
                TraceabilityControl.create(doctor_id: profesional.id, reject_req_id: profesional.id, consultation_control_id: requests.consultation_control.id, status: requests.consultation_control.status)
              end
            else
              requests.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
              requests.consultation.update_attribute(:status, Consultation::RESUELTO)
              requests.consultation.update_attribute(:updated_at, Time.now)
              #Trazabilidad
              TraceabilityConsult.create(doctor_id: profesional.id, reject_req_id: profesional.id, consultation_id: requests.consultation.id, status: requests.consultation.status)
            end
            render status: 200, json: {status: 200, request: requests, message: "Se ha actualizado correctamente."}
          else
            puts "=======> request #{requests.errors.inspect}"
            render status: 411, json: {error: 'No se guardo descartar el requerimiento', request: requests.errors}
          end
        else
          render status: 411, json: {error: "El imei no le pertenece al cliente"}
        end
      end
      #end
    else
      render status: 411, json: {error: 'No existe el requerimiento.'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-30
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: Post
  #
  # Metodo: Compartir formula o mipres al correo de un paciente
  #
  # URL: /api/v1/consultations/shared_formula_mipres.json
  def shared_formula_mipres
    if params[:id].blank? || params[:consultation_id].blank? || params[:tipo].blank?
      render status: 411, json: {error: 'No puede estar vacío'}
    else
      if params[:tipo].to_i == 1
        formula = Formula.formula_info(params[:id], params[:consultation_id])
        if formula.nil?
          render status: 411, json: {message: 'Formula no existe!'}
        else
          EmailDocumentation.formula_patient(formula.specialist_response.consultation.patient_information).deliver_now
          render status: 200, json: {message: 'Enviado correctamente!'}
        end
      elsif params[:tipo].to_i == 2
        mipres = MipresFile.mipres_info(params[:id], params[:consultation_id])
        if mipres.nil?
          render status: 411, json: {message: 'Mipres no existe!'}
        else
          EmailDocumentation.mipres_consult(mipres.specialist_response.consultation.patient_information).deliver_now
          render status: 200, json: {message: 'Enviado correctamente!'}
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-08-12
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: Post
  #
  # Metodo: Trazabilidad de cada consulta o control
  #
  # URL: /api/v1/consultations/traceability.json
  def traceability
    if params[:consultation_id].blank? && params[:consultation_control_id].blank?
      render status: 411, json: {error: 'No puede estar vacío'}
    else
      doctor = User.find_by_authentication_token(params[:user_token])
      if params[:consultation_control_id].blank?
        consulta = Consultation.find_by(id: params[:consultation_id])
        if consulta.nil?
          render status: 411, json: {message: 'La consulta no existe'}
        else
          TraceabilityConsult.create(doctor_id: doctor.id, consultation_id: params[:consultation_id], view_consult_id: doctor.id, type_condition: params[:tipo], status: consulta.status)
          render status: 200, json: {message: 'Creado correctamente!'}
        end
      else
        control = ConsultationControl.find_by(id: params[:consultation_control_id])
        if control.nil?
          render status: 411, json: {message: 'El control no existe'}
        else
          TraceabilityControl.create(doctor_id: doctor.id, consultation_control_id: params[:consultation_control_id], view_control_id: doctor.id, type_condition: params[:tipo], status: control.status)
          render status: 200, json: {message: 'Creado correctamente!'}
        end
      end
    end
  end

private

  # Metodo: Especifica los parametros fuertes de la tabla consulta
  def consultant_params
    params.require(:consultation).permit(:id, :annex_description, :audio_annex, :patient_information_id, :diagnostic_impression, :usuario)
  end
  # Metodo: Especifica los parametros fuertes de la tabla medical consulta
  def medical_consultant_params
    params.require(:medical_consultation).permit(:id, :evolution_time, :weight, :unit_measurement, :number_injuries, :evolution_injuries, :blood, :exude, :suppurate, :symptom, :change_symptom, :other_factors_symptom, :aggravating_factors, :personal_history, :family_background, :treatment_received, :applied_substances, :treatment_effects, :diagnostic_impression, :description_physical_examination, :physical_audio, :reason_consultation, :current_illness)
  end

  # Metodo: Especifica los parametros fuertes de la tabla anexos de imagenes para la consulta
  def consultant_anexo_params
    params.require(:annex_image).permit(:id, :annex_url, :consultation_id, :consultation_control_id)
  end

  # Metodo: Especifica los parametros fuertes de la tabla imagenes del requerimiento
  def images_params
    params.require(:request_image).permit(:image_request, :request_id)
  end

  # Metodo: Especifica los parametros fuertes de la tabla requerimiento
  def request_params
    params.require(:request).permit(:audio_request, :description_request, :status)
  end

  # Metodo: Especifica los parametros fuertes de la tabla requerimiento
  def reject_request_params
    params.require(:request).permit(:reason, :other_reason, :status, :type)
  end
end