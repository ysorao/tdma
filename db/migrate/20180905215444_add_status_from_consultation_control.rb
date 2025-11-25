class AddStatusFromConsultationControl < ActiveRecord::Migration[5.1]
  def change
    add_column :consultation_controls, :status, :integer
  end
end
