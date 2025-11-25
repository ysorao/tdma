class AddImpressionToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :diagnostic_impression, :string
  end
end
