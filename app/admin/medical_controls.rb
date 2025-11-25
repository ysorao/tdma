ActiveAdmin.register MedicalControl do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]

  filter :consultation_id, as: :select, collection: Consultation.all.collect {|u| ['Consulta' + ' #' + u.id.to_s, u.id]}
  filter :doctor_id, as: :select, collection: User.where(type_professional: User::MEDICO).collect {|u| [u.name + ' ' + u.surnames, u.id]}
end
