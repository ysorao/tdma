class Api::V1::Enfermera::NurseConsultController < ApiController


  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion deacuerdo a una consulta en especifico
  def show_info
    if Consultation.find_by(id: params[:consultation_id]).nil?
      @patient_consult = Consultation.includes(:consultation_controls).where("consultation_controls.id = ?", params[:consultation_control_id].to_i).references(:consultation_controls).first
    else
      @patient_consult = Consultation.find(params[:consultation_id])
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite actualizar el analisis de la lesión de la consulta en la respuesta de la enfermera
  def update_nurse_consultation
    if specialist_consult_params[:consultation_id].blank?
      consult = SpecialistResponse.find_by(consultation_control_id: specialist_consult_params[:consultation_control_id])
    else
      consult = SpecialistResponse.find_by(consultation_id: specialist_consult_params[:consultation_id])
    end
    
    if consult.update(specialist_consult_params)
      render status: 200, json: {message: 'Se ha actualizado correctamente'}
    else
      puts "#{consult.errors.to_json}"
      render status: 411, json: {message: 'No se pudo actualizar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualizar campo tratamiento en la consulta (Especialista enfermera)
  def update
    if Consultation.find_by(id: params[:id]).nil?
      consult = ConsultationControl.find(params[:id])
    else
      consult = Consultation.find(params[:id])
    end

    if consult.update_attribute(:recommended_treatment, params[:recommended_treatment])
      render status: 200, json: {message: 'Se ha guardado correctamente'}
    else
      render status: 411, json: {errors: consult.errors, message: 'No se pudo aguardar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: POST
  #
  # Metodo: Almacenar proximo control
  def create_next_control
    if response_params[:consultation_id].blank?
      response = SpecialistResponse.find_by(consultation_control_id: response_params[:consultation_control_id])
    else
      response = SpecialistResponse.find_by(consultation_id: response_params[:consultation_id])
    end

    response.specialist_id = current_user.id
    if response.update(response_params)
      render status: 200, json: {status: 200, response: response, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo el control', response: response.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: POST
  #
  # Metodo: Almacenar requerimiento
  def create_request
    request = Request.new(request_params)
    request.specialist_id = current_user.id
    request.status = 1

    if request.save
      render status: 200, json: {status: 200, request: request, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo el requerimiento', request: request.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion deacuerdo a una consulta en especifico
  def get_info_nurse
    if params[:consultation_id].blank?
      @nurse_specialist_info = SpecialistResponse.find_by(consultation_control_id: params[:consultation_control_id], specialist_id: current_user.id)
    else
      @nurse_specialist_info = SpecialistResponse.find_by(consultation_id: params[:consultation_id], specialist_id: current_user.id)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-16
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Muestra el diagnostico principal y sus controles asociados a la consulta
  def get_history
    #@principal = OtherDiagnostic.where(specialist_response_id: params[:specialist_response_id]).first
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: POST
  #
  # Metodo: Muestra el diagnostico principal y sus controles asociados a la consulta
  def response_consult
    if params[:consultation_id].blank?
      control_response = SpecialistResponse.where(consultation_control_id: params[:consult_control_id]).first
      status_paciente = ConsultationControl.consult_status(control_response.consultation_control.patient_id)
      requirement_control = status_paciente.detect{|w| w == Consultation::REQUERIMIENTO}
    else
      consult_response = SpecialistResponse.where(consultation_id: params[:consultation_id]).first
      estados_paciente = Consultation.consult_status(consult_response.consultation.patient_id)
      requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}
    end

    if params[:flag] == true
      if params[:consultation_id].blank?
        if control_response.consultation_control.requests.count >= 0 && params[:type] == 1
          control_response.consultation_control.update_attribute(:status, Consultation::RESUELTO)
          unless requirement.nil?
            control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
            control_response.consultation_control.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
          else
            control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
            control_response.consultation_control.consultation.update_attribute(:status, Consultation::RESUELTO)
          end
          render status: 200, json: {message: 'Se ha respondido la consulta.'}
        elsif control_response.consultation_control.requests.count > 0
          control_response.consultation_control.update_attribute(:status, Consultation::REQUERIMIENTO)
          control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          control_response.consultation_control.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
          render status: 200, json: {message: 'Se ha respondido la consulta.'}
        else
          render status: 411, json: {error: 'No se pudo responder la consulta ya que requerimiento no tiene información.'}
        end
      else
        if consult_response.consultation.requests.count >= 0 && params[:type] == 1
          consult_response.consultation.update_attribute(:status, Consultation::RESUELTO)
          unless requirement.nil?
            consult_response.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          else
            consult_response.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
          end
          render status: 200, json: {message: 'Se ha respondido la consulta.'}
        elsif consult_response.consultation.requests.count > 0
          consult_response.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
          consult_response.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          render status: 200, json: {message: 'Se ha respondido la consulta.'}
        else
          render status: 411, json: {error: 'No se pudo responder la consulta ya que requerimiento no tiene información.'}
        end
      end
    else
      if params[:consultation_id].blank?
        unless control_response.consultation_control.type_remission.nil? && control_response.consultation_control.remission_comments.nil?
          control_response.consultation_control.update_attribute(:status, Consultation::REMISION)   
          control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REMISION)
          render status: 200, json: {message: 'Paciente esta en remisión'}
        else
          render status: 411, json: {error: 'No se pudo remitir el control de la consulta ya que la información no esta completa.'}
        end
      else
        unless consult_response.consultation.type_remission.nil? && consult_response.consultation.remission_comments.nil?
          consult_response.consultation.update_attribute(:status, Consultation::REMISION)   
          consult_response.consultation.patient_information.update_attribute(:status, Consultation::REMISION)
          render status: 200, json: {message: 'Paciente esta en remisión'}
        else
          render status: 411, json: {error: 'No se pudo remitir la consulta ya que la información no esta completa.'}
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-17
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar las imagenes
  def get_charge_images
    if params[:consultation_id].blank?
      @photos = ImagesInjury.injury_control(params[:consult_control_id], Consultation::ENFERMERA)
    else
      @photos = ImagesInjury.injury_consult(params[:consultation_id], Consultation::ENFERMERA)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-12-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar las imagenes editadas
  def get_edit_images
    if params[:consultation_id].blank?
      photos = ImagesInjury.injury_control(params[:consult_control_id], Consultation::ENFERMERA)
      edited = ImagesInjury.injury_edit_control(params[:consult_control_id], Consultation::ENFERMERA)
      edited.map {|x| x.photo = x.edited_photo.url}
      @edited_photos = (photos + edited).sort
    else
      photos = ImagesInjury.injury_consult(params[:consultation_id], Consultation::ENFERMERA)
      edited = ImagesInjury.injury_edit_consult(params[:consultation_id], Consultation::ENFERMERA)
      edited.map {|x| x.photo = x.edited_photo.url}
      @edited_photos = (photos + edited).sort
    end 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: POST
  #
  # Metodo: Permite crear la respuesta del especialista
  def create_specialist_response
    response = SpecialistResponse.new(response_specialist_params)
    response.specialist_id = current_user.id
    if response_specialist_params[:consultation_id].blank?
      specialist = SpecialistResponse.find_by(consultation_control_id: response_specialist_params[:consultation_control_id])
    else
      specialist = SpecialistResponse.find_by(consultation_id: response_specialist_params[:consultation_id])
    end

    if specialist.nil? && response.save
      render status: 200, json: {status: 200, response: response.id, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {response: specialist.id, message: "Ya fue creado"}
    end 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Editar la imagen de la lesión
  def update_images_injury
    image = ImagesInjury.find(images_injury_params[:id])
    
    if image.update(images_injury_params)
      render status: 200, json: {message: 'Se ha editado la foto correctamente'} 
    else
      render status: 411, json: {error: 'No se pudo actualizar'}   
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-16
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualizar la consulta si es caso remisión
  def update_remission_consult
    if Consultation.find_by(id: params[:consultation_id]).nil?
      consult = ConsultationControl.find(params[:consultation_control_id])
    else
      consult = Consultation.find(params[:consultation_id])
    end

    if consult.update(type_remission: params[:type_remission], remission_comments: params[:remission_comments])
      render status: 200, json: {message: 'Se ha actualizado correctamente'} 
    else
      render status: 411, json: {error: 'No se pudo actualizar', remission: consult.errors}   
    end
  end

  private

  # Metodo: Parametros fuertes de la respuesta especialista (Control)
  def response_params
    params.require(:response_specialist).permit(:control_recommended, :nurse_id, :consultation_id, :consultation_control_id)
  end

  # Metodo: Parametros fuertes de proximo control
  def request_params
    params.require(:request).permit(:comment, :type_request, :consultation_id, :consultation_control_id, :specialist_id, :nurse_id, :status)
  end

  # Metodo: Parametros fuertes de la respuesta dle especialista
  def response_specialist_params
    params.require(:specialist_response).permit(:specialist_id, :consultation_id, :consultation_control_id)
  end

  # Metodo: Parametros fuertes de la respuesta del especialista en la consulta para analisis de caso
  def specialist_consult_params
    params.require(:specialist_response).permit(:consultation_id, :consultation_control_id, :case_analysis, :analysis_description)
  end

  # Metodo: Parametros fuertes de la imagen de la lesión
  def images_injury_params
    params.require(:images_injury).permit(:id, :edited_photo, :commentations)
  end
end