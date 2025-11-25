object @factura

attributes :id, :bill_number, :administrator_entity_code, :administrator_entity_name, :total_value_shared_payment, :net_to_pay_contract_entity

node :ips_insurance_id do |bill|
  IpsInsurance.find(bill.ips_insurance_id).insurance.name 
end

node :bill_expedition_date do |bill|
  bill.bill_expedition_date.strftime("%d/%m/%Y")
end

node :init_date do |bill|
  bill.init_date.strftime("%d/%m/%Y")
end

node :end_date do |bill|
  bill.end_date.strftime("%d/%m/%Y")
end

node :contract_number do |bill|
  bill.contract_number.nil? ? 'No aplica' : bill.contract_number
end

node :benefits_plan do |bill|
  bill.benefits_plan.nil? ? 'No aplica' : bill.benefits_plan
end

node :policy_number do |bill|
  bill.policy_number.nil? ? 'No aplica' : bill.policy_number
end

node :commision_value do |bill|
  bill.commision_value.nil? ? 0 : bill.commision_value
end

node :total_value_discounts do |bill|
  bill.total_value_discounts.nil? ? 0 : bill.total_value_discounts
end