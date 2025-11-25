class AddFieldsToConsultationControl < ActiveRecord::Migration[5.1]
  def change
    add_column :consultation_controls, :specialist_id, :integer
    add_column :consultation_controls, :assistant_id, :integer
    add_column :consultation_controls, :doctor_id, :integer
    add_column :consultation_controls, :nurse_id, :integer
    add_column :consultation_controls, :assign_id, :integer
    add_column :consultation_controls, :recommended_treatment, :string
    add_column :consultation_controls, :diagnostic_impression, :string
    add_column :consultation_controls, :type_remission, :integer
    add_column :consultation_controls, :remission_comments, :text
    add_reference :consultation_controls, :patient, foreign_key: true
  end
end
