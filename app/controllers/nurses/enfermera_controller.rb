# Controlador para funcionalidades de la enfermera
class Nurses::EnfermeraController < ApplicationController

  before_action :authenticate_user!

  before_action :check_permission

  #Permisos
  def check_permission
    unless params[:consult_id].nil?
      if params[:action] != 'update'
        consulta = current_user.specialists.where(id: params[:consult_id])
        control = current_user.specialist_controls.where(id: params[:control_id])

        if consulta.blank?
          redirect_to nurses_enfermera_index_path, alert: "¡Esa consulta no te pertenece o no existe!", format: 'js'
        end
      end
    end

    unless params[:control_id].nil?
      if params[:action] != 'update'
        control = current_user.specialist_controls.where(id: params[:control_id])

        if control.blank?
          redirect_to nurses_enfermera_index_path, alert: "¡Ese control de consulta no te pertenece o no existe!", format: 'js'
        end
      end
    end

    if current_user.type_professional == User::AUXILIAR
      if request.fullpath == "/nurses/enfermera?status=1" || request.fullpath == "/nurses/enfermera?status=8" || request.fullpath == "/nurses/enfermera?status=4"
        redirect_to nurses_enfermera_index_path, alert: "¡No tienes permisos para ejecutar esta acción!"
      end
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
  # Verbo Http: GET
  #
  # Metodo: Permite listar las consultas pendientes
  def index
    #Consulta
    unless params[:consult_id].nil?
      user_consult = Consultation.find(params[:consult_id])
      user_consult.update_attribute(:status, Consultation::EVALUANDO)
      user_consult.update_attribute(:nurse_id, current_user.id)
      redirect_to nurses_enfermera_index_path(status: Consultation::EVALUANDO, option: 2), notice: 'Ha sido asignada', format: 'js' 
    end

    #Control
    unless params[:control_id].nil?
      user_control = ConsultationControl.find(params[:control_id])
      user_control.update_attribute(:status, Consultation::EVALUANDO)
      user_control.update_attribute(:specialist_id, current_user.id)
      redirect_to nurses_enfermera_index_path(status: Consultation::EVALUANDO, option: 2), notice: 'Ha sido asignada', format: 'js' 
    end

    if params[:status].nil? || params[:status].to_i == Consultation::PENDIENTE
      consultas = Consultation.where(specialist_id: nil, status: Consultation::PENDIENTE).where.not(nurse_id: nil).order(created_at: :desc)#.page(params[:page]).per(1)
      asignados = Consultation.where(specialist_id: current_user.id, status: Consultation::PENDIENTE).where.not(nurse_id: nil).order(created_at: :desc)
      controles = ConsultationControl.where(specialist_id: nil, status: Consultation::PENDIENTE).where.not(nurse_id: nil).order(created_at: :desc)
      asignados_control = ConsultationControl.where(specialist_id: current_user.id, status: Consultation::PENDIENTE).where.not(nurse_id: nil).order(created_at: :desc)
      @consults = consultas + controles + asignados + asignados_control
    elsif params[:status].to_i == Consultation::EVALUANDO
      consultas_ev = Consultation.specialist_status(current_user.id, Consultation::EVALUANDO, User::ENFERMERIA)#.page(params[:page]).per(10)
      controles_ev = ConsultationControl.specialist_status(current_user.id, Consultation::EVALUANDO, User::ENFERMERIA)
      @consults = consultas_ev + controles_ev
    elsif params[:status].to_i == Consultation::REQUERIMIENTO
      consultas_req = Consultation.specialist_status(current_user.id, Consultation::REQUERIMIENTO, User::ENFERMERIA)#.page(params[:page]).per(10)
      controles_req = ConsultationControl.specialist_status(current_user.id, Consultation::REQUERIMIENTO, User::ENFERMERIA)
      @consults = consultas_req + controles_req
    else
      consultas_res = Consultation.specialist_status(current_user.id, [Consultation::RESUELTO, Consultation::REMISION], User::ENFERMERIA)#.page(params[:page]).per(10)
      controles_res = ConsultationControl.specialist_status(current_user.id, [Consultation::RESUELTO, Consultation::REMISION], User::ENFERMERIA)
      @consults = consultas_res + controles_res
    end  
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2018-12-13
  #
  # Verbo Http: GET
  #
  # Metodo: Vista Resolver consultas
  def new
    if params[:consult_id].nil?
      @consulta = ConsultationControl.find(params[:control_id])
      patient = ConsultationControl.find(params[:control_id]).patient_id
      @annex_images = AnnexImage.where(consultation_control_id: params[:control_id])
    else
      @consulta = Consultation.find(params[:consult_id])
      patient = Consultation.find(params[:consult_id]).patient_id
      @annex_images = AnnexImage.where(consultation_id: params[:consult_id])
    end
    @consultas = Consultation.where(patient_id: patient, type_profesional: User::ENFERMERA).where.not(status: Consultation::EVALUANDO).order(:created_at)
    @history_control = NurseControl.patient_nurse_control(patient)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Se actualiza la consulta asignandole una enfermera
  def update
    unless params[:consult_id].nil?
      user_consult = Consultation.find(params[:consult_id])
    end
    unless params[:control_id].nil?
      user_consult = ConsultationControl.find(params[:control_id])
    end
    if user_consult.update_attribute(:specialist_id, params[:other_user].to_i)
      user_consult.update_attribute(:status, Consultation::EVALUANDO)
      user_consult.update_attribute(:assign_id, current_user.id)
      redirect_to nurses_enfermera_index_path(status: Consultation::EVALUANDO, option: 2), notice: "Ha sido asignada a #{User.find(params[:other_user]).name}"
    else
      redirect_to nurses_enfermera_index_path(status: Consultation::PENDIENTE, option: 1), notice: 'No se pudo asignar'
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
  # Metodo: Permite generar el pdf con la certificación del especialista
  def generate_certified
    #respond_to do |format|
      #format.html
      #format.pdf do
        #render :pdf => 'OC_HB_' +@purchase_provider.purchase.req.id.to_s+ "_" +company_name,
        #:margin => { :bottom => 18 },
        #:footer =>{ :html => {:template => 'app/auction/purchase_panels/footer.pdf.erb'} },
        #:wkhtmltopdf => '/usr/local/bin/wkhtmltopdf', # Ruta donde se guardo el programa
        #:template => 'app/specialists/especialista/generate_certified.pdf.erb', # se crea una vista pero en vez de .html se coloca .pdf
        #partial: 'foo',
        #zoom: '3.3',
        #print_media_type: true,
        #:handlers => [:erb],
        #:formats => [:pdf],
        #:disposition => 'inline'
      #end
    #end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite consultar los pacientes del especialista
  def search_patient
    @consults = Consultation.includes(:patient).where("patients.number_document = ? AND consultations.status IN (?)", params[:search].to_s, [1,3]).references(:patient) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Vista editar
  def edit
    @account = User.find(params[:id]) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-14
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Permite editar perfil del especialista
  def edit_profile
    @account = User.find(account_params[:id])
    
    if @account.update(account_params)
      redirect_to edit_nurses_enfermera_path(current_user.id), notice: 'Editado correctamente'
    else
      render :edit
    end
  end

  private
  def account_params
    params.require(:user).permit(:id, :photo, :name, :surnames, :number_document, :professional_card, :phone, :email, :password, :password_confirmation, :photo_cache)
  end
end