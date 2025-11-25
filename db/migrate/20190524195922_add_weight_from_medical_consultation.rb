class AddWeightFromMedicalConsultation < ActiveRecord::Migration[5.1]
  def change
    add_column :medical_consultations, :weight, :string
  end
end
