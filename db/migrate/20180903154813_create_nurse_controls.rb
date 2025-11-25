class CreateNurseControls < ActiveRecord::Migration[5.1]
  def change
    create_table :nurse_controls do |t|
      t.integer :subjetive_improvement
      t.integer :ulcer_length
      t.integer :ulcer_width
      t.integer :pain_intensity
      t.boolean :tolerated_treatment
      t.boolean :improvement
      t.references :consultation_control, foreign_key: true

      t.timestamps
    end
  end
end
