class Api::V1::Especialista::ConsultController < ApiController


  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-09
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
  # Fecha creacion: 2018-07-09
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear diagnosticos de respuesta a la consulta
  def create
    diagnostic = OtherDiagnostic.new(consult_diagnostic_params)
    diagnostic.status = 1 

    if diagnostic.save
      render status: 200, json: {status: 200, consultant: diagnostic, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo el diagnostico del paciente', consultant: diagnostic.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-09
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: PUT
  #
  # Metodo: Actualizar campo tratamiento en la consulta (Especialista)
  def edit_consult
    if Consultation.find_by(id: params[:consultation_id]).nil?
      consult = ConsultationControl.find(params[:consultation_control_id])
    else
      consult = Consultation.find(params[:consultation_id])
    end

    if consult.update_attribute(:recommended_treatment, params[:recommended_treatment])
      render status: 200, json: {message: 'Se ha guardado correctamente'}
    else
      render status: 411, json: {errors: consult.errors, message: 'No se pudo aguardar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Almacenar en la biblioteca del especialista un tratamiento
  def create_library_treatment
    library = LibrarySpecialist.new(name: params[:name], specialist_response_id: params[:specialist_response_id], specialist_id: current_user.id)
    if library.save
      render status: 200, json: {status: 200, specialist_treatment: library, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo el diagnostico del paciente', specialist_treatment: library.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Almacenar en la biblioteca del especialista una formulación
  #FIXME REVISAR SI CON UN METODO SE PUEDE OPTMIZAR MANDADO TIPO 1 o 2
  def create_library_formula
    respuesta = SpecialistResponse.includes(:formulas).where("formulas.specialist_response_id = ? AND specialist_responses.specialist_id = ?", params[:specialist_response_id], current_user.id).references(:formulas)
    
    if respuesta.blank?
      render status: 411, json: {error: 'No se pudo guardar porque se debe tener al menos una formula'}
    else
      formula = Formula.where(specialist_response_id: respuesta.last.id).last  
      puts "aqui esta el idddddddd #{formula.inspect}"
      library = LibrarySpecialist.new(name: params[:name], specialist_response_id: params[:specialist_response_id], specialist_id: current_user.id, formula_id: formula.id)
      
      if library.save
        render status: 200, json: {status: 200, specialist_formula: library, message: "Se ha guardado correctamente."}
      else
        render status: 411, json: {error: 'No se guardo la formulación', specialist_formula: library.errors}
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-11
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: POST
  #
  # Metodo: Solicitud de examenes por parte del especialista la paciente
  def create_request_exam
    exam = RequestExam.new(request_exam_params)
    exam.specialist_id = current_user.id
    exam.status = 1
    if exam.save
      render status: 200, json: {status: 200, request_exam: exam, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo la solicitud del examen', request_exam: exam.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Almacenar formulas de la consulta
  def create_formula
    formula = Formula.new(formula_params)
    if formula.save
      render status: 200, json: {status: 200, formula: formula, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo la formula', formula: formula.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Adjuntar archivo Mipress
  def create_formula_mipress
    file = MipresFile.new(mipres: params[:file], specialist_response_id: params[:specialist_response_id])
    if file.save
      render status: 200, json: {status: 200, mipres_file: file, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: file.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-12
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
  # Fecha creacion: 2018-07-12
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
  # Fecha creacion: 2018-07-16
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion deacuerdo a una consulta en especifico
  def get_info_specialist
    if params[:consultation_id].blank?
      @specialist_info = SpecialistResponse.find_by(consultation_control_id: params[:consultation_control_id])
    else
      @specialist_info = SpecialistResponse.find_by(consultation_id: params[:consultation_id])
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-16
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-13
  #
  # Verbo Http: GET
  #
  # Metodo: Muestra el diagnostico principal y sus controles asociados a la consulta
  def get_history
    #@principal = OtherDiagnostic.where(specialist_response_id: params[:specialist_response_id]).first 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-16
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
      SpecialistResponse.find_by(consultation_control_id: params[:consult_control_id]).update_attribute(:specialist_id, current_user.id)
    else
      consult_response = SpecialistResponse.where(consultation_id: params[:consultation_id]).first
      estados_paciente = Consultation.consult_status(consult_response.consultation.patient_id)
      requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}
      SpecialistResponse.find_by(consultation_id: params[:consultation_id]).update_attribute(:specialist_id, current_user.id)
    end
    #Si se le da click al boton responder consulta en la pestaña RESPUESTA O REQUERIMIENTO
    if params[:flag] == true
      if params[:consultation_id].blank?
        #Si guarda un diagnostico
        if control_response.other_diagnostics.count > 0 && control_response.consultation_control.requests.count >= 0
          #Ha guardado diagnostico y le dio responder consulta en la pestaña REQUERIMIENTO
          if params[:tipo].to_s == "2"
            control_response.consultation_control.update_attribute(:status, Consultation::REQUERIMIENTO)
          else
            control_response.consultation_control.update_attribute(:status, Consultation::RESUELTO)
          end

          control_response = SpecialistResponse.where(consultation_control_id: params[:consult_control_id]).first
          status_paciente = ConsultationControl.consult_status(control_response.consultation_control.patient_id)
          requirement_control = status_paciente.detect{|w| w == Consultation::REQUERIMIENTO}

          if requirement_control.nil?
            control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
          else
            control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          end
          #Trazabilidad
          TraceabilityControl.create(user_id: current_user.id, consultation_control_id: control_response.consultation_control_id, status: control_response.consultation_control.status)
          render status: 200, json: {message: 'Se ha respondido el control de la consulta.', page: new_specialists_especialistum_path(control_id: control_response.consultation_control_id) }
        elsif control_response.consultation_control.requests.count > 0
          control_response.consultation_control.update_attribute(:status, Consultation::REQUERIMIENTO)
          control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          control_response.consultation_control.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
          #Trazabilidad
          TraceabilityControl.create(user_id: current_user.id, consultation_control_id: control_response.consultation_control_id, status: control_response.consultation_control.status)
          render status: 200, json: {message: 'Se ha respondido el control de la consulta.', page: new_specialists_especialistum_path(control_id: control_response.consultation_control_id)}
        else
          render status: 411, json: {error: 'No se pudo responder el control de la consulta ya que diagnóstico o requerimiento no tiene información.'}
        end
      else
        if consult_response.other_diagnostics.count > 0 && consult_response.consultation.requests.count >= 0
          if params[:tipo].to_s == "2"
            consult_response.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
            consult_response.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          else
            consult_response.consultation.update_attribute(:status, Consultation::RESUELTO)
          end

          consult_response = SpecialistResponse.where(consultation_id: params[:consultation_id]).first
          estados_paciente = Consultation.consult_status(consult_response.consultation.patient_id)
          requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}

          if requirement.nil?
            consult_response.consultation.patient_information.update_attribute(:status, Consultation::RESUELTO)
          else
            consult_response.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          end
          #Trazabilidad
          TraceabilityConsult.create(user_id: current_user.id, consultation_id: consult_response.consultation_id, status: consult_response.consultation.status)
          render status: 200, json: {message: 'Se ha respondido la consulta.', page: new_specialists_especialistum_path(consult_id: consult_response.consultation_id)}
        elsif consult_response.consultation.requests.count > 0
          consult_response.consultation.update_attribute(:status, Consultation::REQUERIMIENTO)
          consult_response.consultation.patient_information.update_attribute(:status, Consultation::REQUERIMIENTO)
          
          #Trazabilidad
          TraceabilityConsult.create(user_id: current_user.id, consultation_id: consult_response.consultation_id, status: consult_response.consultation.status)
          render status: 200, json: {message: 'Se ha respondido la consulta.', page: new_specialists_especialistum_path(consult_id: consult_response.consultation_id)}
        else
          render status: 411, json: {error: 'No se pudo responder la consulta ya que diagnóstico o requerimiento no tiene información.'}
        end
      end
    else
      if params[:consultation_id].blank?
        unless control_response.consultation_control.type_remission.nil? && control_response.consultation_control.remission_comments.nil?
          control_response.consultation_control.update_attribute(:status, Consultation::REMISION)   
          control_response.consultation_control.consultation.patient_information.update_attribute(:status, Consultation::REMISION)
          control_response.consultation_control.consultation.update_attribute(:status, Consultation::REMISION)
          #Trazabilidad
          TraceabilityControl.create(user_id: current_user.id, consultation_control_id: control_response.consultation_control_id, status: control_response.consultation_control.status)
          render status: 200, json: {message: 'Paciente esta en remisión', page: new_specialists_especialistum_path(control_id: control_response.consultation_control_id)}
        else
          render status: 411, json: {error: 'No se pudo remitir el control de la consulta ya que la información no esta completa.'}
        end
      else
        unless consult_response.consultation.type_remission.nil? && consult_response.consultation.remission_comments.nil?
          consult_response.consultation.update_attribute(:status, Consultation::REMISION)   
          consult_response.consultation.patient_information.update_attribute(:status, Consultation::REMISION)
          consult_response.consultation.update_attribute(:status, Consultation::REMISION)
          #Trazabilidad
          TraceabilityConsult.create(user_id: current_user.id, consultation_id: consult_response.consultation_id, status: consult_response.consultation.status)
          render status: 200, json: {message: 'Paciente esta en remisión', page: new_specialists_especialistum_path(consult_id: consult_response.consultation_id)}
        else
          render status: 411, json: {error: 'No se pudo remitir la consulta ya que la información no esta completa.'}
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-17
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los tratamientos de la biblioteca de un especialista
  def get_library_treatment
    @treatments = LibrarySpecialist.where(specialist_id: current_user.id, formula_id: nil)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-17
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-27
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los medicamentos para diagnostico
  def get_autocomplete_diagnostic
    if params[:consult].blank?
      consult = ConsultationControl.find(params[:control]).consultation.patient_information
    else
      consult = Consultation.find(params[:consult]).patient_information
    end
    if consult.purpose_consultation >= 2 && consult.purpose_consultation <= 8
      @diseases = Disease.where("code BETWEEN ? AND ? AND LOWER(name) ILIKE('%#{params[:term].downcase}%')", "Z000", "Z999")
    else
      @diseases = Disease.where("LOWER(name) ILIKE ? OR LOWER(code) ILIKE ?", "%#{params[:term].downcase}%", "%#{params[:term].downcase}%")
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-17
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar desde biblioteca el tratamiento
  def get_treatment_specialist
    @treatment = LibrarySpecialist.find(params[:id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-17
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Permite cargar desde biblioteca el tratamiento
  def delete_library_treatment
    library_treatment = LibrarySpecialist.find(params[:id])
    
    if library_treatment.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-18
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los tratamientos de la biblioteca de un especialista
  def get_library_formula
    @formulas = LibrarySpecialist.where(specialist_id: current_user.id).where.not(formula_id: nil)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-18
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar desde biblioteca el tratamiento
  def get_formula_specialist
    @formula = LibrarySpecialist.find(params[:id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-18
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Permite cargar desde biblioteca el tratamiento
  def delete_library_formula
    library_formula = LibrarySpecialist.find(params[:id])
    
    if library_formula.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-18
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar las imagenes
  def get_charge_images
    if params[:consultation_id].blank?
      @photos = ImagesInjury.injury_control(params[:consult_control_id], Consultation::MEDICO)
    else
      @photos = ImagesInjury.injury_consult(params[:consultation_id], Consultation::MEDICO)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-12-17
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar las imagenes editadas
  def get_edit_images
    orden, cont = [], 0
    if params[:consultation_id].blank? 
      photos = ImagesInjury.injury_control(params[:consult_control_id].split("-")[0], Consultation::MEDICO)
      edited = ImagesInjury.injury_edit_control(params[:consult_control_id].split("-")[0], Consultation::MEDICO)
      edited.map {|x| x.photo = x.edited_photo.url}
      photos.each do |x|
        orden.push(x)
        edited.each do |y|
          if x.id == y.image_injury_id
            orden.push(y)
          elsif x.id == y.id
            orden.push(y)
          end
        end
      end
      @edited_photos = orden
    else
      photos = ImagesInjury.injury_consult(params[:consultation_id].split("-")[0], Consultation::MEDICO)
      edited = ImagesInjury.injury_edit_consult(params[:consultation_id].split("-")[0], Consultation::MEDICO)
      edited.map {|x| x.photo = x.edited_photo.url}
      photos.each do |x|
        orden.push(x)
        edited.each do |y|
          if x.id == y.image_injury_id
            orden.push(y)
          elsif x.id == y.id
            orden.push(y)
          end
        end
      end
      @edited_photos = orden
    end 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-12-04
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar las imagenes dermatoscopicas a partir de su imagen original
  def dermatoscopy_images
    @dermatoscopy = ImagesInjury.images_dermatoscopies(params[:father_id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-07
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-12
  #
  # Verbo Http: GET
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
  # Fecha creacion: 2018-09-19
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2019-04-02
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite actualizar el analisis de la lesión de la consulta en la repsuesta del espcialista
  def update_specialist_consultation
    if params[:consultation_id].blank?
      consult = SpecialistResponse.find_by(consultation_control_id: params[:consultation_control_id])
    else
      consult = SpecialistResponse.find_by(consultation_id: params[:consultation_id])
    end
    
    if params[:type].to_s == "1"
      if consult.update_attribute(:case_analysis, params[:case_analysis])
        render status: 200, json: {message: 'Se ha actualizado correctamente'}
      else
        puts "#{consult.errors.to_json}"
        render status: 411, json: {message: 'No se pudo actualizar'}
      end
    else
      if consult.update_attribute(:analysis_description, params[:analysis_description])
        render status: 200, json: {message: 'Se ha actualizado correctamente'}
      else
        puts "#{consult.errors.to_json}"
        render status: 411, json: {message: 'No se pudo actualizar'}
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion: 
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Permite crear un analisis para la biblioteca
  def create_library_analysis
    library = LibraryAnalysis.new(name: params[:name], specialist_response_id: params[:specialist_response_id], type_analysis: params[:type])
    if library.save
      render status: 200, json: {status: 200, specialist_library_analysis: library, message: "Se ha guardado correctamente."}
    else
      render status: 411, json: {error: 'No se guardo el analisis en la biblioteca', specialist_library_analysis: library.errors}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los analisis de lesion de la biblioteca de un especialista
  def get_library_injury_analysis
    @analisis_lesiones = LibraryAnalysis.injury_analysis(current_user.id)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar desde biblioteca el analisis de lesión
  def get_injury_analysis_specialist
    @analisis_lesion = LibraryAnalysis.find(params[:id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Permite borrar el analisis de la lesion que se encuentra la biblioteca del especialista
  def delete_library_injury_analysis
    library_injury_analysis = LibraryAnalysis.find(params[:id])
    
    if library_injury_analysis.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los analisis de caso de la biblioteca de un especialista
  def get_library_case_analysis
    @analisis_casos = LibraryAnalysis.case_analysis(current_user.id)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite cargar desde biblioteca el analisis de caso
  def get_case_analysis_specialist
    @analisis_caso = LibraryAnalysis.find(params[:id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-04-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Permite borrar el analisis de caso que se encuentra la biblioteca del especialista
  def delete_library_case_analysis
    library_case_analysis = LibraryAnalysis.find(params[:id])
    
    if library_case_analysis.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
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

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-02-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion de la evolucion de la consulta principal y sus controles
  def evolution_consults
    if params[:consult_id].blank?
      control = ConsultationControl.find(params[:control_id])
      principal_consult = Consultation.where(id: control.consultation_id, status: [1,2,7])
      @consult_control = principal_consult + ConsultationControl.where(consultation_id: control.consultation_id, status: [1,2,7,8]).order(:id)
    else
      principal_consult = Consultation.find(params[:consult_id])
      @consult_control = [principal_consult] + ConsultationControl.where(consultation_id: principal_consult.id, status: [1,2,7,8]).order(:id)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-02-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion del medical control
  def get_consults_control
    if params[:consult_first_id].nil?
      @control = MedicalControl.find_by(consultation_control_id: params[:show_id])
    else
      @control = MedicalConsultation.find_by(consultation_id: params[:consult_first_id])
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-02-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion de la consulta y sus controles para la respuesta del especialista
  def evolution_specialist
    if params[:consult_id].blank?
      control = ConsultationControl.find(params[:control_id])
      principal_consult = Consultation.where(id: control.consultation_id, status: [1,2,7])
      @specialist = principal_consult + ConsultationControl.where(consultation_id: control.consultation_id, status: [1,2,7,8]).order(:id)
    else
      principal_consult = Consultation.find(params[:consult_id])
      @specialist = [principal_consult] + ConsultationControl.where(consultation_id: principal_consult.id, status: [1,2,7,8]).order(:id)
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-02-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Mostrar la informacion de la respuesta del especialista
  def get_response_specialist
    if params[:consult_id_first].blank?
      @specialist_info = SpecialistResponse.find_by(consultation_control_id: params[:show_esp_id])
    else
      @specialist_info = SpecialistResponse.find_by(consultation_id: params[:consult_id_first])
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-17
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite verficar si existen diagnosticos de la consulta
  def get_diagnostic_consult
    diagnostics = OtherDiagnostic.includes(specialist_response: :consultation).where("consultations.id = ?", params[:consultation_id]).references(specialist_response: :consultation).count
    render status: 200, json: {diagnostico: diagnostics}
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-01-09
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Creditos de un cliente (Total y disponibles)
  def client_credits
    client = User.find_by_authentication_token(params[:user_token]).user_clients.first.client_id
    total = PrepayCardClient.total_credits(client) + PrepayCard.prepay_additional(client)
    consumidos = Client.find(client).available_credits
    render status: 200, json: {total: total, consumidos: consumidos}
  end

  private

  # Metodo: Parametros fuertes de otros diagnosticos
  def consult_diagnostic_params
    params.require(:other_diagnostic).permit(:disease_id, :type_diagnostic, :related_diagnosis_one, :related_diagnosis_two, :related_diagnosis_three, :specialist_response_id, :status)
  end

  # Metodo: Parametros fuertes de solicitud de examenes
  def request_exam_params
    params.require(:request_exam).permit(:name_type_exam, :specialist_response_id, :specialist_id, :status)
  end

  # Metodo: Parametros fuertes de formulas
  def formula_params
    params.require(:formula).permit(:medication_code, :type_medicament, :generic_name_medicament, :pharmaceutical_form, :drug_concentration, :unit_measure_medication, :number_of_units, :commentations, :specialist_response_id)
  end

  # Metodo: Parametros fuertes de la respuesta especialista (Control)
  def response_params
    params.require(:response_specialist).permit(:control_recommended, :specialist_id, :consultation_id, :consultation_control_id)
  end

  # Metodo: Parametros fuertes de proximo control
  def request_params
    params.require(:request).permit(:comment, :type_request, :consultation_id, :consultation_control_id, :specialist_id, :status)
  end

  # Metodo: Parametros fuertes de la respuesta dle especialista
  def response_specialist_params
    params.require(:specialist_response).permit(:specialist_id, :consultation_id, :consultation_control_id)
  end

  # Metodo: Parametros fuertes de la imagen de la lesión
  def images_injury_params
    params.require(:images_injury).permit(:id, :edited_photo, :commentations)
  end
end