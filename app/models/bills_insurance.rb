class BillsInsurance < ApplicationRecord
  belongs_to :ips_insurance, optional: true
  belongs_to :client, optional: true

  validates :client_id, :ips_insurance_id, :init_date, :end_date, :bill_number, :bill_expedition_date, :init_date, :end_date, :administrator_entity_code, :administrator_entity_name, :net_to_pay_contract_entity, presence: true
  validate :expedition_date?
  validate :init_date?, unless: :fechas? 
  validate :end_date?, unless: :fechas?
  validate :entity_code?
  validate :shared_payment?

  validates :value_consultation, :value_moderator_fee, :total_value_shared_payment, :commision_value, :total_value_discounts, :net_to_pay_contract_entity, numericality: { only_integer: true }


  def fechas?
    self.init_date == nil || self.end_date == nil
  end

  #Validar fecha de expedicion de factura
  def expedition_date?
    unless self.bill_expedition_date.nil?
      if self.bill_expedition_date.to_date >= Date.today.to_date
        errors.add(:bill_expedition_date, "La fecha de expedición de la factura no puede ser mayor a la actual")
      end
    end
  end

  #Validar fecha de inicio
  def init_date?
    unless self.init_date.nil?
      if self.init_date.to_date >= Date.today.to_date
        errors.add(:init_date, "La fecha de inicio no puede ser mayor o igual a la actual")
      elsif self.init_date > self.end_date
        errors.add(:init_date, "La fecha de inicio no puede ser mayor a la fecha final")
      end
    end
  end

  #Validar fecha final
  def end_date?
    unless self.end_date.nil?
      if self.end_date.to_date >= Date.today.to_date
        errors.add(:end_date, "La fecha final no debe ser mayor a la actual")
      elsif self.end_date > self.bill_expedition_date
        errors.add(:end_date, "La fecha final no debe ser mayor a la fecha de expedición")
      elsif self.end_date < self.bill_expedition_date
        errors.add(:end_date, "La fecha final no debe ser menor a la fecha de expedición")
      elsif self.end_date < self.init_date
        errors.add(:end_date, "La fecha final no puede ser menor a la fecha inicio")
      end
    end
  end

  #Validar código entidad administrador en (EAPB)
  def entity_code?
    unless self.administrator_entity_code.nil?
    	if self.administrator_entity_code.length <= 6
    	  eapb = Insurance.find_by_code(self.administrator_entity_code)
        if eapb.nil?
          errors.add(:administrator_entity_code, "El código no es válido.")   
        end
      elsif self.administrator_entity_code.length != 11
        errors.add(:administrator_entity_code, "El NIT debe ser de 11 caracteres")
      end
    end
  end

  #Validar pago compartido (copago)
  def shared_payment?
    unless self.net_to_pay_contract_entity.nil?
      if self.net_to_pay_contract_entity < 0
        errors.add(:net_to_pay_contract_entity, "No se permite valores negativos")  
      end
    end
  end

  #Permite convertir la información a un csv para la generacion de (AF - RIPS)
  def self.to_csv
    CSV.generate do |csv|
      factura = all.last
      fa = factura.attributes
      cli = factura.client.attributes
      rip_af = {a: cli['code_service_provider'], b: cli['business_name'].upcase, 
                c: Client.name_document(cli['type_identification']), d: cli['identification_number'].sub("-",""),
                e: fa['bill_number'].upcase, f: fa['bill_expedition_date'].strftime("%d/%m/%Y"), g: fa['init_date'].strftime("%d/%m/%Y"),
                h: fa['end_date'].strftime("%d/%m/%Y"), i: fa['administrator_entity_code'].upcase, j: IpsInsurance.find(fa['ips_insurance_id']).insurance.name,
                k: fa['contract_number'], l: fa['benefits_plan'], m: fa['policy_number'].nil? ? 0 : fa['policy_number'], n: fa['total_value_shared_payment'].nil? ? 0 : fa['total_value_shared_payment'],
                o: fa['commision_value'].nil? ? 0 : fa['commision_value'], p: fa['total_value_discounts'].nil? ? 0 : fa['total_value_discounts'], q: fa['net_to_pay_contract_entity'].nil? ? 0 : fa['net_to_pay_contract_entity']}
      csv << rip_af.values
    end
  end
end
