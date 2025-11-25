ActiveAdmin.register Injury do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]

  filter :consultation_id, as: :select, collection: Consultation.all.collect {|u| ['Consulta' + ' #' + u.id.to_s, u.id]}
  filter :body_area, as: :select, collection: BodyArea.all.collect {|u| [u.name, u.id]}
end
