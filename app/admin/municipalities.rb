ActiveAdmin.register Municipality do
  menu false
  actions :all, except: [:new, :edit, :destroy]
  #menu :parent => "Historia clínica", priority: 5
end
