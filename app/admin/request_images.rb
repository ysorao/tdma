ActiveAdmin.register RequestImage do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]

  filter :request_id, as: :select, collection: Request.all.collect {|u| [u.comment, u.id]}
end
