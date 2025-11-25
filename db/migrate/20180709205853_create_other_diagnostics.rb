class CreateOtherDiagnostics < ActiveRecord::Migration[5.1]
  def change
    create_table :other_diagnostics do |t|
      t.references :specialist_response, foreign_key: true
      t.references :disease, foreign_key: true
      t.integer :type_diagnostic
      t.integer :status

      t.timestamps
    end
  end
end
