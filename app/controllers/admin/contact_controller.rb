# Controlador para funcionalidades de Contacto
class Admin::ContactController < ApplicationController

  before_action :authenticate_admin_user!

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Actualizar el contacto con la respuesta
  def response_update
  	contact = Contact.find(contacts_params[:id])
    contact.status = Contact::RESUELTO
    if contact.update(contacts_params)
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, response_contact: true, contact_id: contact.id)
      EmailDocumentation.answer_contact(contact).deliver_now
      redirect_to admin_contacts_path, notice: "Ha sido respondido"
    else
      redirect_to response_form_admin_contacts_path(id: contact.id), alert: "No se pudo responder#{contact.errors.count}"
    end
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Asignar administrador al contacto
  def assign_update
  	contact = Contact.find(params[:contact_id])
  	unless contact.nil?
      TraceabilityAdmin.create(admin_user_id: current_admin_user.id, assign_contact: true, contact_id: contact.id)   
      contact.update_attribute(:admin_user_id, params[:other_contact].to_i)
      contact.update_attribute(:status, Contact::EVALUANDO)
      redirect_to admin_contacts_path, notice: "Ha sido asignada."
    else
      redirect_to assign_admin_admin_contacts_path(id: contact.id), notice: 'No se pudo asignar'
    end
  end

  private

  # Metodo: Especifica los parametros fuertes de la tabla contacto
  def contacts_params
    params.require(:contact).permit(:id, :response_contact, :admin_user_id, :status)
  end
end