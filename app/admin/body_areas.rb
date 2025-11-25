ActiveAdmin.register BodyArea do
  menu false
  actions :all, except: [:new, :edit, :destroy]
  #menu :parent => "Historia clínica", priority: 2
end
