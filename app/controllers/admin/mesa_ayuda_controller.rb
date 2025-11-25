# Controlador para funcionalidades de Mesa de ayuda
class Admin::MesaAyudaController < ApplicationController

  before_action :authenticate_admin_user!

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 11-06-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Actualizar el ticket con la respuesta
  def response_update
  	desk = HelpDesk.find(help_desks_params[:id])
    desk.status = HelpDesk::RESUELTO
    if desk.update(help_desks_params)
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, response_help_desk: true, help_desk_id: desk.id)
      HistoryTicket.create(message_create: "Se creó el ticket en la fecha #{desk.created_at.strftime("%d-%m-%Y %I:%m%P")}", message_assign: "Se asigno el ticket a #{desk.admin_user.email}", message_response: "El ticket lo ha respondido #{desk.admin_user.email}", help_desk_id: desk.id)
      redirect_to admin_help_desks_path, notice: "Ha sido respondido el ticket #{desk.ticket}."
      EmailDocumentation.answer_request(desk).deliver_now
    else
      redirect_to response_form_admin_help_desks_path(id: desk.id), alert: "No se pudo responder#{desk.errors.count}"
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 11-06-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Actualizar administrador
  def assign_update
  	help_desk = HelpDesk.find(params[:desk_id])
  	unless help_desk.nil?
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, assign_help_desk: true, help_desk_id: help_desk.id)   
      help_desk.update_attribute(:admin_user_id, params[:other_admin].to_i)
      help_desk.update_attribute(:status, HelpDesk::EVALUANDO)
      redirect_to admin_help_desks_path, notice: "Ha sido asignada."
    else
      redirect_to assign_admin_admin_help_desks_path(id: help_desk.id), notice: 'No se pudo asignar'
    end
  end

  private

  # Metodo: Especifica los parametros fuertes de la tabla consulta
  def help_desks_params
    params.require(:help_desk).permit(:id, :response_ticket, :image_admin, :status)
  end
end