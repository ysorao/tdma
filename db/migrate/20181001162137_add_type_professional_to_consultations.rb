class AddTypeProfessionalToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :type_profesional, :integer
  end
end
