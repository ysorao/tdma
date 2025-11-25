ActiveAdmin.register Request do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]

  filter :consultation_id, as: :select, collection: Consultation.all.collect {|u| ['Consulta' + ' #' + u.id.to_s, u.id]}
end
