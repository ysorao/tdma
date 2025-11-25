class Api::V1::NurseControlsController < ApiController


  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear control
  #
  # URL: /api/v1/nurse_controls.json
  def create
    consult_control = ConsultationControl.new(consultation_control_params)
    consult_control.type_professional = ConsultationControl::ENFERMERA
    consult_control.usuario = params[:user_token]
    consult_control.status = 3

    consulta = Consultation.find(consultation_control_params[:consultation_id])
    consult_control.patient_id = consulta.patient_id

    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      unless validate_imei(request.headers["imei"], current_user).nil?
        control_nurse = NurseControl.new(nurse_control_params)
        #Permite verificar si el control de enfermeria se ha guardado en caso contrario hace un Rollback
        #control_nurse.transaction do
          #begin
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
              control_nurse.consultation_control_id = consult_control.id    
              if control_nurse.save!
                render status: 200, json: {status: 200, consulta_control: consult_control, control_enfermera: control_nurse, message: "Se guardo correctamente"}
              else
                puts "=======> nurse_control #{control_nurse.errors.inspect}"
                render status: 411, json: {error: control_nurse.errors} 
              end
            else
              puts "=======> consultation_control #{consult_control.errors.inspect}"
              render status: 411, json: {error: consult_control.errors}   
            end
          #rescue
            #render status: 411, json: {error: control_nurse.errors} 
            #raise ActiveRecord::Rollback
          #end
        #end
      else
        render status: 411, json: {error: "El imei no le pertenece al cliente"}
      end
    end
  end

private

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Especifica los parametros fuertes de la tabla consulta control
  def consultation_control_params
    params.require(:consultation_control).permit(:id, :consultation_id, :type_professional, :usuario)
  end

  # Metodo: Especifica los parametros fuertes de la tabla control enfermera
  def nurse_control_params
    params.require(:nurse_control).permit(:id, :subjetive_improvement, :ulcer_length, :ulcer_width, :pain_intensity, :tolerated_treatment, :improvement, :consultation_control_id, :commentation)
  end
end