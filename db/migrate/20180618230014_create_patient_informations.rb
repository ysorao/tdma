class CreatePatientInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :patient_informations do |t|
      t.boolean :terms_conditions, default: false
      t.integer :unit_measure_age
      t.integer :age
      t.integer :civil_status
      t.string :occupation
      t.string :phone
      t.string :email
      t.string :address
      t.references :municipality, foreign_key: true
      t.integer :urban_zone
      t.boolean :companion, default: false
      t.string :name_companion
      t.string :phone_companion
      t.boolean :responsible, default: false
      t.string :name_responsible
      t.string :phone_responsible
      t.string :relationship
      t.integer :type_user
      t.string :authorization_number
      t.string :code_consultation
      t.integer :purpose_consultation
      t.integer :external_cause
      t.integer :status
      t.references :patient, foreign_key: true
      t.references :insurance, foreign_key: true

      t.timestamps
    end
  end
end
