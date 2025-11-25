ActiveAdmin.register DesignedResponse do

  permit_params :title, :description, :status
  menu priority: 15

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Muestra los campos de la tabla designed
  index do
    column :id
    column :title
    column :description
    column :status do |d|
      if d.status == DesignedResponse::ACTIVO
        span :class => "", :style => " border:none; background-color: rgb(44, 145, 40); color: white;height:30px; padding: 5px;" do
          var = "Activo"
        end
      else
        span :class => "", :style => " border:none; background-color: red; color: white;height:30px; padding: 5px;" do
          var = "Inactivo"
        end
      end
    end
    actions defaults: true do |des|
      if des.status == User::ACTIVO
        item('Desactivar', inactivate_admin_designed_response_path(id: des.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
      elsif des.status == User::INACTIVO
        item('Activar', activate_admin_designed_response_path(id: des.id), data: { confirm: 'Estas Seguro(a)?', method: :put }, method: :put, class: "member_link")
      end
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
  # Metodo: que se encarga del editar y nuevo
  form do |f|
    f.inputs 'Respuestas prediseñadas' do
      f.input :title
      f.input :description, as: :text
      f.input :status, as: :hidden, :input_html => { value: 1 }
    end
    f.actions
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Activa un usuario y actualiza su estado
  member_action :activate, method: :put do
    designed = DesignedResponse.find(params[:id])
    designed.update_attribute(:status, DesignedResponse::ACTIVO)
    redirect_to admin_designed_responses_path(id: designed.id), notice: 'Activada'
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 04-09-2019
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Desactiva un usuario y actualiza su estado
  member_action :inactivate, method: :put do
    designed = DesignedResponse.find(params[:id])
    designed.update_attribute(:status, DesignedResponse::INACTIVO)
    redirect_to admin_designed_responses_path(id: designed.id), alert: 'Desactivada'
  end
end
