class AddFieldsToMedicalConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_consultations, :reason_consultation, :text
    add_column :medical_consultations, :current_illness, :text
  end
end
