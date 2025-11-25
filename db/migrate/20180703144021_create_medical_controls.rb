class CreateMedicalControls < ActiveRecord::Migration[5.1]
  def change
    create_table :medical_controls do |t|
      t.integer :doctor_id
      t.references :consultation, foreign_key: true
      t.string :subjetive_improvement
      t.boolean :did_treatment, default: false
      t.integer :tolerated_medications
      t.text :audio_clinic
      t.text :clinic_description
      t.text :audio_annex
      t.text :annex_description
      t.text :annex_photo
      t.references :consultation_control, foreign_key: true

      t.timestamps
    end
    add_index :medical_controls, :doctor_id
  end
end
