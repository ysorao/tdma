# Controlador para funcionalidades de trazabilidad de administracion
class Admin::TraceabilityAdminController < ApplicationController

  before_action :authenticate_admin_user!

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 17-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Actualizar trazabilidad
  def assignment
    if params[:consultation_id].blank?
      control = ConsultationControl.find(params[:consultation_control_id])
      if params[:type] == 'asignar'
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, assign_control_id: params[:other_user], consultation_control_id: params[:consultation_control_id])
        control.update_attribute(:specialist_id, params[:other_user].to_i)
        control.update_attribute(:status, Consultation::EVALUANDO)   
      else
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, reassign_control_id: params[:other_user], consultation_control_id: params[:consultation_control_id])
        control.update_attribute(:specialist_id, params[:other_user].to_i) 
      end
      redirect_to admin_consultation_controls_path, notice: "Ha sido asignada."
    else
      consulta = Consultation.find(params[:consultation_id])
    	if params[:type] == 'asignar'
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, assign_consult_id: params[:other_user], consultation_id: params[:consultation_id])
        consulta.update_attribute(:specialist_id, params[:other_user].to_i)
        consulta.update_attribute(:status, Consultation::EVALUANDO)   
      else
        TraceabilityAdmin.create(admin_user_id: current_admin_user.id, reassign_consult_id: params[:other_user], consultation_id: params[:consultation_id])
        consulta.update_attribute(:specialist_id, params[:other_user].to_i) 
      end
      redirect_to admin_consultations_path, notice: "Ha sido asignada."
    end
  end
end