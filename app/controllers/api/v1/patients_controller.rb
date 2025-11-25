class Api::V1::PatientsController < ApiController

  include ProofGlobalModule

  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Buscar paciente
  #
  # URL: /api/v1/patients/4343543543.json
  def show
    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      unless validate_imei(request.headers["imei"], current_user).nil?
        @patient = Patient.find_by_number_document(params[:id])
        @patient.blank? ? Patient.new.as_json : @patient 
      else
        Patient.new.as_json
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-20
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear paciente
  #
  # URL: /api/v1/patient/patients.json
  def create
    if params[:patient][:number_document].blank?
      p = Patient.where(type_document: params[:patient][:type_document], type_condition: params[:patient][:type_condition]).last
    else
      p = Patient.find_by_number_document(params[:patient][:number_document])
    end

    if p.nil?
      patient = Patient.new(patient_params)
      patient.municipio = params[:patient_information][:municipality_id].to_i
      patient.cliente = params[:user_token] 
      unless patient.save
        puts "=======> patient #{patient.errors.inspect}"
        render status: 411, json: {error: 'No se guardo la información del paciente', patient: patient.errors}
        return
      end
      extra_info = patient.patient_informations.new(patient_information_params)
    end

    unless p.nil?
      if params[:patient][:number_document].blank?
        patient = Patient.new(patient_params)
        patient.municipio = params[:patient_information][:municipality_id].to_i
        patient.cliente = params[:user_token] 
          if patient.save
            extra_info = patient.patient_informations.new(patient_information_params)
          #extra_info.patient_id = patient.id
          end
      else
        extra_info = p.patient_informations.new(patient_information_params)
      end
    end
   
    if extra_info.save
      render status: 200, json: {status: 200, patient: patient, patient_information: extra_info, message: "Se ha guardado correctamente."}
    else
      puts "=======> patient_information #{extra_info.errors.inspect}"
      render status: 411, json: {error: 'No se guardo la información del paciente', patient_id: p.nil? ? patient.id : p.id, patient_information: extra_info.errors}
    end 
  end

  private

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-19
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Especifica los parametros fuertes de la tabla paciente
  def patient_params
    params.require(:patient).permit(:id, :type_document, :type_condition, :number_document, :name, :second_name, :last_name, :second_surname, :birthdate, :genre, :number_inpec, :client_id)
  end

  # Metodo: Especifica los parametros fuertes de la tabla paciente informacion
  def patient_information_params
    params.require(:patient_information).permit(:id, :terms_conditions, :unit_measure_age, :age, :civil_status, :phone, :occupation, :email, :address, :municipality_id, :urban_zone, :companion, :name_companion, :phone_companion, :responsible, :name_responsible, :phone_responsible, :relationship, :type_user, :authorization_number, :purpose_consultation, :external_cause, :insurance_id, :patient_id)
  end
end