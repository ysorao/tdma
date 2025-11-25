class Api::V1::MedicalControlsController < ApiController


  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear consulta
  #
  # URL: /api/v1/medical_controls.json
  def create
    consult_control = ConsultationControl.new(consultation_control_params)
    consult_control.type_professional = ConsultationControl::MEDICO
    consult_control.usuario = params[:user_token]
    consult_control.status = 3

    consulta = Consultation.find(consultation_control_params[:consultation_id])
    consult_control.patient_id = consulta.patient_id

    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      unless validate_imei(request.headers["imei"], current_user).nil?
        if consult_control.save
          #Verifica si tiene creditos la IPS
          card = Client.enabled_credits(current_user)
          if card.first.available_credits == 0
            consult_control.update_attribute(:status, Consultation::SIN_CREDITOS)
            consult_control.update_attribute(:updated_at, Time.now)
            consult_control.patient.patient_informations.last.update_attribute(:status, Consultation::SIN_CREDITOS)
            NotificationCreditsWorker.perform_async(card.first.id)
          else
            card.first.update_attribute(:available_credits, (card.first.available_credits - 1))

            #Verifica si alguna consulta sigue en estado requerimiento o pendiente
            estados_paciente = ConsultationControl.consult_status(consult_control.patient_id)
            requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}

            if !requirement.nil?
              consult_control.patient.patient_informations.last.update_attribute(:status, Consultation::REQUERIMIENTO)
            else
              consult_control.patient.patient_informations.last.update_attribute(:status, Consultation::PENDIENTE)
            end  
          end
          control_medico = MedicalControl.new(control_medical_params)
          control_medico.usuario = params[:user_token]
          control_medico.consultation_control_id = consult_control.id
          control_medico.consultation_id = consult_control.consultation_id
          if control_medico.save
            #Trazabilidad
            TraceabilityControl.create(doctor_id: consult_control.doctor_id, consultation_control_id: consult_control.id)
            render status: 200, json: {status: 200, consulta_control: consult_control, control_medico: control_medico, message: "Se guardo correctamente"}
          else
            puts "=======> medical_control #{control_medico.errors.inspect}"
            render status: 411, json: {error: control_medico.errors} 
          end
        else
          puts "=======> consultation_control #{consult_control.errors.inspect}"
          render status: 411, json: {error: consult_control.errors}   
        end
      else
        render status: 411, json: {error: "El imei no le pertenece al cliente"}
      end
    end
    #CreateMedicalControlWorker.perform_async(params[:medical_control][:consultation_id], params[:medical_control][:subjetive_improvement], params[:medical_control][:did_treatment], params[:medical_control][:tolerated_medications], params[:medical_control][:audio_clinic], params[:medical_control][:clinic_description], params[:medical_control][:audio_annex], params[:medical_control][:annex_description], params[:medical_control][:annex_photo], params[:user_email], params[:images])
    #control = MedicalControl.where(consultation_id: params[:medical_control][:consultation_id], subjetive_improvement: params[:medical_control][:subjetive_improvement], tolerated_medications: params[:medical_control][:tolerated_medications]).last
    #render status: control.nil? ? 411 : 200, json: {status: control.nil? ? 411 : 200, control: control, error: control_medico.errors, images: control.nil? ? [] : control.images_injuries, message: control.nil? ? "No se guardo el control de la consulta del paciente" : "Se guardo correctamente"}
  end

private

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-06
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Especifica los parametros fuertes de la tabla control medico
  def consultation_control_params
    params.require(:consultation_control).permit(:id, :consultation_id, :type_professional, :status, :usuario)
  end

  # Metodo: Especifica los parametros fuertes de la tabla consulta control
  def control_medical_params
    params.require(:medical_control).permit(:id, :subjetive_improvement, :did_treatment, :tolerated_medications, :audio_clinic, :clinic_description, :audio_annex, :annex_description, :usuario, :consultation_id)
  end
end