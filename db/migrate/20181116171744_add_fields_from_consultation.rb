class AddFieldsFromConsultation < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :type_remission, :integer
    add_column :consultations, :remission_comments, :text
  end
end
