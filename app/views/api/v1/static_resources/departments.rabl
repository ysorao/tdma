object @departments

attributes :id, :name

child :municipalities do

  attributes :id, :name, :code, :department_id, :code_department
end