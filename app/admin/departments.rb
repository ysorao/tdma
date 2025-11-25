ActiveAdmin.register Department do
  menu false
  actions :all, except: [:new, :edit, :destroy]
  #menu :parent => "Historia clínica", priority: 4
end
