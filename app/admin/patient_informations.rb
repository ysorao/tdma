ActiveAdmin.register PatientInformation do
  menu false
  actions :all, except: [:new, :create, :edit, :update, :show, :destroy]

  filter :municipality_id, as: :select, collection: Municipality.all.collect {|u| [u.name, u.id]}
  filter :patient_id, as: :select, collection: Patient.all.collect {|u| [u.name.to_s + ' ' + u.second_name.to_s + ' ' + u.last_name.to_s + ' ' + u.second_surname.to_s, u.id]}
  filter :insurance_id, as: :select, collection: Insurance.all.collect {|u| [u.name, u.id]}
end
