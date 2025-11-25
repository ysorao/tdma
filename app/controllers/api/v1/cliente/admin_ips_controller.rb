class Api::V1::Cliente::AdminIpsController < ApiClientController

  respond_to :json

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista las sedes por cliente
  def get_subsidiary
    @sede = Subsidiary.where(client_id: params[:client_id])
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear una sede del cliente
  def create_subsidiaries
   sede = Subsidiary.new(subsidiaries_params)
    if sede.save
      render status: 200, json: {message: "La sede ha sido creada correctamente", page: subsidiaries_clients_cliente_index_path.to_s}
    else
      render status: 411, json: {error: "No se guardo la sede", message_error: sede.errors.messages}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-02
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Permite borrar la o las sedes seleccionadas por la tabla
  def delete_subsidiaries
    sedes = Subsidiary.find(params[:ids])
    
    if sedes.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista las aseguradoras
  def get_insurances
    @aseguradora = IpsInsurance.where(client_id: params[:client_id].to_i)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear una aseguradora
  def create_insurance
    aseguradora = IpsInsurance.new(ips_insurances_params)
    if aseguradora.save
      render status: 200, json: {message: "La aseguradora ha sido creada correctamente"}
    else
      render status: 411, json: {error: "No se guardo la aseguradora", message_error: aseguradora.errors.messages}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Eliminar una o varias aseguradoras
  def delete_insurances
    aseguradoras = IpsInsurance.find(params[:ids])
    
    if aseguradoras.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se puede eliminar la aseguradora ya que tiene asociada una factura.'}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista los kits del cliente
  def get_kits_client
    @kits = Kit.kits_client(params[:client_id])
  end

  # Autor: Orlando Guzman Londono
  #
  # Fecha creacion: 2018-10-01
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Metodo: Lista las aseguradoras filtradas por palabra
  def autocomplete_insurance
    name_insurance, insurance_completos = [], []
    Insurance.where("LOWER(name) ILIKE('%#{params[:term].downcase}%')").each do |aux|
      name_insurance.push("#{aux.name}")
      insurance_completos.push({id: aux.id, name_complete: "#{aux.name}"})
    end 
    render status: 200, json: {nombres: name_insurance, nombres_completos: insurance_completos, message: "OK"}
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: GET
  #
  # Metodo: Lista las facturas de la aseguradoras
  def get_bills_insurances
    @factura = BillsInsurance.where(client_id: params[:client_id].to_i)
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-11-03
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: POST
  #
  # Metodo: Crear una factura de la aseguradora
  def create_bill_insurance
    factura = BillsInsurance.new(bills_insurances_params)

    puts factura.inspect
    if factura.save
      render status: 200, json: {message: "La factura de la aseguradora ha sido creada correctamente", page: bills_insurances_clients_cliente_index_path.to_s}
    else
      render status: 411, json: {error: "No se guardo la factura de la aseguradora", message_error: factura.errors.messages}
    end
  end

  # Autor: Orlando Guzman Londoño
  #
  # Fecha creacion: 2018-10-11
  #
  # Autor actualizacion:
  #
  # Fecha actualizacion:
  #
  # Verbo Http: DELETE
  #
  # Metodo: Eliminar factura(s) aseguradoras
  def delete_bills_insurance
    facturas = BillsInsurance.find(params[:ids])
    
    if facturas.destroy
      render status: 200, json:{message: "Elimino correctamente" }
    else
      render status: 411, json:{error: 'No se pudo borrar'}
    end
  end

  private

  # Metodo: Parametros fuertes sedes del cliente
  def subsidiaries_params
    params.require(:subsidiary).permit(:id, :name, :identification, :kit_id, :municipality_id, :address, :post_code, :email, :phone_one, :type_subs, :code_sds, :client_id)  
  end

  # Metodo: Parametros fuertes aseguradoras del cliente
  def ips_insurances_params
    params.require(:ips_insurance).permit(:id, :client_id, :insurance_id)  
  end

  # Metodo: Parametros fuertes factura aseguradoras del cliente
  def bills_insurances_params
    params.require(:bills_insurance).permit(:id, :client_id, :ips_insurance_id, :bill_number, :bill_expedition_date, :init_date, :end_date, :administrator_entity_code, :administrator_entity_name, :contract_number, :benefits_plan, :policy_number, :value_consultation, :value_moderator_fee, :total_value_shared_payment, :commision_value, :total_value_discounts, :net_to_pay_contract_entity)  
  end
end