ActiveAdmin.register Disease do
  menu false
  actions :all, except: [:new, :edit, :destroy]
  #menu :parent => "Historia clínica", priority: 3
end
