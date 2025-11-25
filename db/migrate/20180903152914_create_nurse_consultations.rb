class CreateNurseConsultations < ActiveRecord::Migration[5.1]
  def change
    create_table :nurse_consultations do |t|
      t.string :ulcer_etiology
      t.string :ulcer_etiology_other
      t.integer :pain_intensity
      t.integer :ulcer_length
      t.integer :ulcer_width
      t.string :infection_signs
      t.string :wound_tissue
      t.string :skin_among_ulcer
      t.string :ulcer_handle
      t.string :ulcer_handle_aposito
      t.string :ulcer_handle_other
      t.string :consultation_reason_description
      t.string :consultation_reason_audio
      t.integer :pulses_pedio
      t.integer :pulses_femoral
      t.integer :pulses_tibial
      t.references :consultation, foreign_key: true

      t.timestamps
    end
  end
end
