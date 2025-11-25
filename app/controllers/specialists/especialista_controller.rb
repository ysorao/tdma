# Controlador para funcionalidades del especialista
class Specialists::EspecialistaController < ApplicationController

  before_action :authenticate_user!, :except => [:generate_certified]

  before_action :check_permission, :except => [:generate_certified]

  #Permisos
  def check_permission
    #unless params[:consult_id].nil?
      #if params[:action] != 'update'
        #consulta = current_user.specialists.where(id: params[:consult_id])
        #control = current_user.specialist_controls.where(id: params[:control_id])

        #if consulta.blank?
          #redirect_to specialists_especialista_path, alert: "¡Esa consulta no te pertenece o no existe!", format: 'js'
        #end
      #end
    #end

    #unless params[:control_id].nil?
      #if params[:action] != 'update'
        #control = current_user.specialist_controls.where(id: params[:control_id])

        #if control.blank?
          #redirect_to specialists_especialista_path, alert: "¡Ese control de consulta no te pertenece o no existe!", format: 'js'
        #end
      #end
    #end

    if current_user.type_professional == User::AUXILIAR
      if request.fullpath == "/specialists/especialista?status=1&option=3" || request.fullpath == "/specialists/especialista?status=8&option=2" || request.fullpath == "/specialists/especialista?status=4"
        redirect_to specialists_especialista_path, alert: "¡No tienes permisos para ejecutar esta acción!"
      end
    end
  end

  #Metodo de reutilizacion para (update y reasign_consult)
  def type_entity(consult, control, other_user, entity)
    unless consult.nil?
      user_consult = Consultation.find(consult)
      response = SpecialistResponse.find_by(consultation_id: user_consult.id)
      unless response.nil?
        response.update_attribute(:specialist_id, other_user)
      end
      
      if entity == true
        #Trazabilidad
        TraceabilityConsult.create(user_id: other_user, assign_consult_id: current_user.id, consultation_id: user_consult.id, status: user_consult.status)
      else
        #Trazabilidad
        TraceabilityConsult.create(user_id: other_user, reassign_consult_id: current_user.id, consultation_id: user_consult.id, status: user_consult.status)
      end
      
      return user_consult
    end
    unless control.nil?
      user_consult = ConsultationControl.find(control)
      response = SpecialistResponse.find_by(consultation_control_id: user_consult.id)
      unless response.nil?
        response.update_attribute(:specialist_id, other_user)
      end
    
      if entity == true
        #Trazabilidad
        TraceabilityControl.create(user_id: other_user, assign_control_id: current_user.id, consultation_control_id: user_consult.id, status: user_consult.status)
      else
        #Trazabilidad
        TraceabilityControl.create(user_id: other_user, reassign_control_id: current_user.id, consultation_control_id: user_consult.id, status: user_consult.status) 
      end
      
      return user_consult
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-06-13
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion: 2018-07-07
  #
  # Verbo Http: GET
  #
  # Metodo: Permite listar las consultas pendientes
  def index
    #Consulta
    unless params[:consult_id].nil?
      user_consult = Consultation.find(params[:consult_id])
      user_consult.update_attribute(:status, Consultation::EVALUANDO)
      user_consult.update_attribute(:specialist_id, current_user.id)
      redirect_to specialists_especialista_path(status: Consultation::EVALUANDO, option: 2), notice: 'Ha sido asignada', format: 'js' 
    end
    #Control
    unless params[:control_id].nil?
      user_control = ConsultationControl.find(params[:control_id])
      user_control.update_attribute(:status, Consultation::EVALUANDO)
      user_control.update_attribute(:specialist_id, current_user.id)
      redirect_to specialists_especialista_path(status: Consultation::EVALUANDO, option: 2), notice: 'Ha sido asignada', format: 'js' 
    end

    if params[:status].nil? || params[:status].to_i == Consultation::PENDIENTE
      consultas = Consultation.where(specialist_id: nil, status: Consultation::PENDIENTE).where.not(doctor_id: nil).order(created_at: :asc)#.page(params[:page]).per(1)
      consultas_asignadas = Consultation.where(specialist_id: current_user.id, status: Consultation::PENDIENTE).where.not(doctor_id: nil).order(created_at: :asc)
      controles = ConsultationControl.where(specialist_id: nil, status: Consultation::PENDIENTE).where.not(doctor_id: nil).order(created_at: :asc)
      controles_asignados = ConsultationControl.where(specialist_id: current_user.id, status: Consultation::PENDIENTE).where.not(doctor_id: nil).order(created_at: :asc)
      @consults = (consultas + controles + consultas_asignadas + controles_asignados).sort_by {|obj| obj.updated_at}
    elsif params[:status].to_i == Consultation::EVALUANDO
      consultas_ev = Consultation.specialist_status(current_user.id, Consultation::EVALUANDO, User::DERMATOLOGO).order(created_at: :asc)#.page(params[:page]).per(10)
      controles_ev = ConsultationControl.specialist_status(current_user.id, Consultation::EVALUANDO, User::DERMATOLOGO).order(created_at: :asc)
      @consults = (consultas_ev + controles_ev).sort_by {|obj| obj.updated_at}
    elsif params[:status].to_i == Consultation::REQUERIMIENTO
      consultas_req = Consultation.specialist_status(current_user.id, Consultation::REQUERIMIENTO, User::DERMATOLOGO).order(created_at: :asc)#.page(params[:page]).per(10)
      controles_req = ConsultationControl.specialist_status(current_user.id, Consultation::REQUERIMIENTO, User::DERMATOLOGO).order(created_at: :asc)
      @consults = (consultas_req + controles_req).sort_by {|obj| obj.updated_at}
    else
      consultas_res = Consultation.includes(:specialist).where("consultations.specialist_id = ? AND consultations.status IN (?) AND users.type_specialist = ?", current_user.id, [Consultation::RESUELTO, Consultation::REMISION], User::DERMATOLOGO).order(updated_at: :desc).references(:specialist)#.page(params[:page]).per(10)
      controles_res = ConsultationControl.includes(:specialist_control).where("consultation_controls.specialist_id = ? AND consultation_controls.status IN (?) AND users.type_specialist = ?", current_user.id, [Consultation::RESUELTO, Consultation::REMISION], User::DERMATOLOGO).order(updated_at: :desc).references(:specialist_control)
      @consults = (consultas_res + controles_res).sort_by(&:updated_at).reverse
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
  # Verbo Http: GET
  #
  # Metodo: Vista Resolver consultas
  def new
    if params[:consult_id].nil?
      @consulta = ConsultationControl.find(params[:control_id])
      patient = ConsultationControl.find(params[:control_id]).patient_id
      @annex_images = AnnexImage.where(consultation_control_id: params[:control_id])
      #Trazabilidad
      TraceabilityControl.create(consultation_control_id: params[:control_id], view_control_id: current_user.id, status: @consulta.status)
    else
      @consulta = Consultation.find(params[:consult_id])
      patient = Consultation.find(params[:consult_id]).patient_id
      @annex_images2 = AnnexImage.where(consultation_id: params[:consult_id])
      #Trazabilidad
      TraceabilityConsult.create(consultation_id: params[:consult_id], view_consult_id: current_user.id, status: @consulta.status)
    end
    @consultas = Consultation.where(patient_id: patient, type_profesional: User::MEDICO).where.not(status: Consultation::EVALUANDO).order(:created_at)
    @history_control = MedicalControl.patient_medical_control(patient)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-07-06
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Se actualiza la consulta asignandole un especialista
  def update 
    user_consult = type_entity(params[:consult_id], params[:control_id], params[:other_user].to_i, true)
    if user_consult.update_attribute(:specialist_id, params[:other_user].to_i)
      user_consult.update_attribute(:status, Consultation::EVALUANDO)
      user_consult.update_attribute(:assign_id, current_user.id)
      redirect_to specialists_especialista_path(status: Consultation::EVALUANDO, option: 2), notice: "Ha sido asignada a #{User.find(params[:other_user]).name}"
    else
      redirect_to specialists_especialista_path(status: Consultation::PENDIENTE, option: 1), notice: 'No se pudo asignar'
    end  
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 15-04-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Permite generar el pdf con la certificación del doctor
  def generate_certified
    @user = User.find(params[:u])

    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'Certificado_Telederma',
        :margin => { top: 5, left: 0, right: 0, bottom: 0 },
        :wkhtmltopdf => '/usr/local/bin/wkhtmltopdf', # Ruta donde se guardo el programa
        :template => 'specialists/especialista/generate_certified.pdf.erb', # se crea una vista pero en vez de .html se coloca .pdf
        partial: 'foo',
        zoom: '2.0',
        print_media_type: true,
        :handlers => [:erb],
        :formats => [:pdf],
        :disposition => 'inline'
      end
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
  # Metodo: Permite consultar los pacientes del especialista
  def search_patient
    if params[:search].nil?
      @consults = []    
    else
      @consults = Consultation.consults_patient(params[:search].to_s)
      if Consultation.consults_patient(params[:search].to_s).blank?
        #Trazabilidad
        TraceabilityControl.create(patient_specialist_id: current_user.id)
      else
        #Trazabilidad
        TraceabilityConsult.create(patient_specialist_id: current_user.id)
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista editar
  def edit
    @profile = User.find(params[:id]) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-26
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite editar perfil del especialista
  def edit_profile
    @profile = User.find(profile_params[:id])
    
    if @profile.update(profile_params)
      redirect_to edit_specialists_especialistum_path(current_user.id), notice: 'Editado correctamente'
    else
      render :edit
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-12
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite asignar varias consultas y controles a un especialista
  def assign_massive
    unless params[:consult_ids].nil?
      consults = Consultation.find(params[:consult_ids].split(","))

      consults.each do |cons|
        cons.update_attribute(:specialist_id, params[:other_user].to_i)
        cons.update_attribute(:assign_id, current_user.id)
        cons.update_attribute(:status, Consultation::EVALUANDO)
        #Trazabilidad
        TraceabilityConsult.create(user_id: params[:other_user].to_i, assign_consult_id: current_user.id, status: cons.status)
      end
    end

    unless params[:control_ids].nil?
      controls = ConsultationControl.find(params[:control_ids].split(","))

      controls.each do |cont|
        cont.update_attribute(:specialist_id, params[:other_user].to_i)
        cont.update_attribute(:assign_id, current_user.id)
        cont.update_attribute(:status, Consultation::EVALUANDO)
        #Trazabilidad
        TraceabilityControl.create(user_id: params[:other_user].to_i, assign_control_id: current_user.id, status: cont.status)
      end 
    end
      redirect_to specialists_especialista_path(status: Consultation::EVALUANDO, option: 2), notice: "Ha sido asignada a #{User.find(params[:other_user]).name}"
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-05-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: PUT
  #
  # Metodo: Permite reasignar una consulta a otro especialista
  def reasign_consult
    user_consult = type_entity(params[:consult_id], params[:control_id], params[:user_specialist].to_i, false)
    if user_consult.update_attribute(:specialist_id, params[:user_specialist].to_i)
      user_consult.update_attribute(:assign_id, current_user.id)
      redirect_to specialists_especialista_path(status: Consultation::EVALUANDO, option: 2), notice: "Ha sido asignada a #{User.find(params[:user_specialist]).name}"
    else
      redirect_to specialists_especialista_path(status: Consultation::PENDIENTE, option: 1), notice: 'No se pudo asignar'
    end 
  end

  private
  def profile_params
    params.require(:user).permit(:id, :photo, :name, :surnames, :number_document, :professional_card, :phone, :email, :password, :password_confirmation, :photo_cache)
  end
end