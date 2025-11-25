class ChangeDataTypeToSymptom < ActiveRecord::Migration[5.1]
  def self.up
    change_table :medical_consultations do |t|
      t.change :symptom, :string
    end
  end
  def self.down
    change_table :medical_consultations do |t|
      t.change :symptom, :integer
    end
  end
end
