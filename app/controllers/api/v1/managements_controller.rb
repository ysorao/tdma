class Api::V1::ManagementsController < ApiController

  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2019-06-12
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los tickets y su historiales
  #
  # URL: /api/v1/managements.json
  def index
    user = User.find_by_authentication_token(params[:user_token])
    @ticket = HelpDesk.where(user_id: user.id) 
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-12
  #
  # Autor actualizacion: Orlando Guzman Londoño
  #
  # Fecha actualizacion: 2019-06-12
  #
  # Verbo Http: POST
  #
  # Metodo: Crear mesa de ayuda
  #
  # URL: /api/v1/managements.json
  def create
    desk = HelpDesk.new(help_desk_params)
    
    if request.headers["imei"].blank?
      render status: 411, json: {error: "El imei no puede estar vacío"}
    else
      unless validate_imei(request.headers["imei"], current_user).nil?
        device = Device.find_by(imei: request.headers["imei"])
        user = User.find_by_authentication_token(params[:user_token])
        desk.user_id = user.id
        desk.device_id = device.id
        cont = HelpDesk.last
        cont.nil? ? desk.ticket = 1 : desk.ticket = cont.ticket.next
        desk.status = HelpDesk::PENDIENTE
        if desk.save
          help_desk = {id: desk.id, subject: desk.subject, description: desk.description, ticket: desk.ticket, 
                       user_id: desk.user_id, status: desk.status, device_id: desk.device_id,
                       created_at: desk.created_at, updated_at: desk.updated_at, response_ticket: desk.response_ticket, 
                       image_user: desk.image_user, image_admin: desk.image_admin.url, admin_user_id: desk.admin_user_id}
          
          EmailDocumentation.help_desk(desk, request.headers["imei"]).deliver_later

          render status: 200, json: {status: 200, desk: help_desk, message: "Se ha enviado la solicitud de ayuda a la mesa de servicio y se notificará a su correo cuando sea solucionado. Gracias."}
        else
          render status: 411, json: {error: desk.errors} 
        end
      end
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-09-12
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear auditoria
  #
  # URL: /api/v1/managements/update.json
  def update
    audit = Audit.new(audit_params)
    
    if audit.save
      render status: 200, json: {status: 200, audit: audit, message: "Se guardo correctamente"}
    else
      render status: 411, json: {error: audit.errors} 
    end
  end

  private

  # Metodo: Especifica los parametros fuertes de la tabla auditoría
  def audit_params
    params.require(:audit).permit(:id, :description, :date_action, :user_id, :device_id)
  end
  # Metodo: Especifica los parametros fuertes de la tabla mesa de ayuda
  def help_desk_params
    params.require(:help_desk).permit(:id, :subject, :image_user, :description, :ticket, :user_id, :status, :device_id)
  end
end