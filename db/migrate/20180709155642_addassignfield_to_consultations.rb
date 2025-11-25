class AddassignfieldToConsultations < ActiveRecord::Migration[5.1]
  def change
  	add_column :consultations, :assign_id, :integer
  end
end
