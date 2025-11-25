class CreateConsultations < ActiveRecord::Migration[5.1]
  def change
    create_table :consultations do |t|
      t.text :annex_description
      t.string :audio_annex
      t.datetime :date_archived
      t.integer :status
      t.references :patient, foreign_key: true
      t.references :patient_information, foreign_key: true
      t.integer :specialist_id
      t.integer :assistant_id
      t.integer :doctor_id
      t.integer :nurse_id

      t.timestamps
    end
      add_index :consultations, :specialist_id
      add_index :consultations, :assistant_id
      add_index :consultations, :doctor_id
      add_index :consultations, :nurse_id
  end
end
