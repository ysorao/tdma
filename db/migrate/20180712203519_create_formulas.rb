class CreateFormulas < ActiveRecord::Migration[5.1]
  def change
    create_table :formulas do |t|
      t.string :medication_code
      t.string :type_medicament
      t.string :generic_name_medicament
      t.string :pharmaceutical_form
      t.string :drug_concentration
      t.string :unit_measure_medication
      t.string :number_of_units
      t.string :unit_value_medicament
      t.string :total_value_medicament
      t.references :specialist_response, foreign_key: true

      t.timestamps
    end
  end
end
