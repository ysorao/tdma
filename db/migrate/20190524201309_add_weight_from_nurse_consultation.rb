class AddWeightFromNurseConsultation < ActiveRecord::Migration[5.1]
  def change
    add_column :nurse_consultations, :weight, :string
  end
end
