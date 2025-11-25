class Api::V1::NurseConsultationsController < ApiController

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
  # Metodo: Crear consulta de enfermería
  #
  # URL: /api/v1/nurse_consultations.json
  def create
    consulta = Consultation.new(consultant_params)
    consulta.usuario = params[:user_token]

    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      unless validate_imei(request.headers["imei"], current_user).nil?
        if consulta.save
          #Verifica si tiene creditos la IPS
          card = Client.enabled_credits(current_user)
          if card.first.available_credits == 0
            consulta.update_attribute(:status, Consultation::SIN_CREDITOS)
            consulta.update_attribute(:updated_at, Time.now)
            consulta.patient_information.update_attribute(:status, Consultation::SIN_CREDITOS)
            NotificationCreditsWorker.perform_async(card.first.id)
          else
            card.first.update_attribute(:available_credits, (card.first.available_credits - 1))

            #Verifica si alguna consulta sigue en estado requerimiento o pendiente
            estados_paciente = Consultation.consult_status(consulta.patient_id)
            requirement = estados_paciente.detect{|w| w == Consultation::REQUERIMIENTO}

            if !requirement.nil?
              consulta.patient.patient_informations.last.update_attribute(:status, Consultation::REQUERIMIENTO)
            else
              consulta.patient.patient_informations.last.update_attribute(:status, Consultation::PENDIENTE)
            end  
          end
          nurse_consulta = NurseConsultation.new(nurse_consultant_params)

          if nurse_consulta.save
            nurse_consulta.update_attribute(:consultation_id, consulta.id)
            render status: 200, json: {status: 200, consultant: consulta, nurse_consulta: nurse_consulta, message: "Se ha guardado correctamente."}
          else
            puts "=======> nurse_consulta #{nurse_consulta.errors.inspect}"
            render status: 411, json: {error: 'No se guardo la consulta del paciente', nurse_consulta: nurse_consulta.errors}
          end
        else
          puts "=======> consultation #{consulta.errors.inspect}"
          render status: 411, json: {error: 'No se guardo la consulta del paciente', consultant: consulta.errors}
        end
      else
        render status: 411, json: {error: "El imei no le pertenece al cliente"}
      end
    end
  end

  private

  # Metodo: Especifica los parametros fuertes de la tabla consulta
  def consultant_params
    params.require(:consultation).permit(:id, :annex_description, :audio_annex, :patient_information_id)
  end
  # Metodo: Especifica los parametros fuertes de la tabla consulta
  def nurse_consultant_params
    params.require(:nurse_consultation).permit(:id, :ulcer_etiology, :weight, :ulcer_etiology_other, :pain_intensity, :ulcer_length, :ulcer_width, :infection_signs, :wound_tissue, :skin_among_ulcer, :ulcer_handle, :ulcer_handle_aposito, :ulcer_handle_other, :consultation_reason_description, :consultation_reason_audio, :pulses_pedio, :pulses_femoral, :pulses_tibial)
  end
end