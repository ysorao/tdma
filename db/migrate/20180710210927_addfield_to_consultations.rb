class AddfieldToConsultations < ActiveRecord::Migration[5.1]
  def change
  	add_column :consultations, :recommended_treatment, :string
  end
end
