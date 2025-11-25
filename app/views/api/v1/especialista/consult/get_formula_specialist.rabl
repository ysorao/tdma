object @formula

attributes :id

node :formulation do |library_form|
  library_form.nil? ? [] : partial("api/v1/formulas/show_web", object: library_form.formula)
end