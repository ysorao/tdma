class CreateMedicalConsultations < ActiveRecord::Migration[5.1]
  def change
    create_table :medical_consultations do |t|
      t.integer :symptom
      t.float :evolution_time
      t.integer :unit_measurement
      t.integer :number_injuries
      t.string :evolution_injuries
      t.boolean :blood
      t.boolean :exude
      t.boolean :suppurate
      t.integer :change_symptom
      t.string :other_factors_symptom
      t.string :aggravating_factors
      t.string :personal_history
      t.string :family_background
      t.string :treatment_received
      t.string :applied_substances
      t.string :treatment_effects
      t.string :diagnostic_impression
      t.text :description_physical_examination
      t.string :physical_audio
      t.string :annex_description
      t.string :audio_annex
      t.references :consultation, foreign_key: true

      t.timestamps
    end
  end
end
