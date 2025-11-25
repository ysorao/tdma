ActiveAdmin.register Insurance do
  menu false
  actions :all, except: [:new, :edit, :destroy]
  #menu :parent => "Historia clínica", priority: 1
end
