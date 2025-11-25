#Información de las formulas del especialista (WEB)
object @formulas

attributes :id, :medication_code, :type_medicament, :generic_name_medicament, :pharmaceutical_form, :drug_concentration, :unit_measure_medication, :number_of_units, :unit_value_medicament, :total_value_medicament, :specialist_response_id, :commentations

node :medication_code do |formula|
  formula.medication_code.nil? ? 'Ninguno' : formula.medication_code
end

node :type_medicament do |formula|
  formula.type_medicament.nil? ? 'Ninguno' : formula.type_medicament
end

node :generic_name_medicament do |formula|
  formula.generic_name_medicament.nil? ? 'Ninguno' : formula.generic_name_medicament
end

node :pharmaceutical_form do |formula|
  formula.pharmaceutical_form.nil? ? 'Ninguno' : formula.pharmaceutical_form
end

node :drug_concentration do |formula|
  formula.drug_concentration.nil? ? 'Ninguno' : formula.drug_concentration
end

node :unit_measure_medication do |formula|
  formula.unit_measure_medication.nil? ? 'Ninguno' : formula.unit_measure_medication
end

node :number_of_units do |formula|
  formula.number_of_units.nil? ? 'Ninguno' : formula.number_of_units
end

node :unit_value_medicament do |formula|
  formula.unit_value_medicament.nil? ? 'Ninguno' : formula.unit_value_medicament
end

node :total_value_medicament do |formula|
  formula.total_value_medicament.nil? ? 'Ninguno' : formula.total_value_medicament
end

node :commentations do |formula|
  formula.commentations.nil? ? 'Ninguno' : formula.commentations
end