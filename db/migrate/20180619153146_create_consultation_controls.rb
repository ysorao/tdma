class CreateConsultationControls < ActiveRecord::Migration[5.1]
  def change
    create_table :consultation_controls do |t|
      t.integer :type
      t.references :consultation, foreign_key: true

      t.timestamps
    end
  end
end
