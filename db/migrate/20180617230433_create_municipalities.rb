class CreateMunicipalities < ActiveRecord::Migration[5.1]
  def change
    create_table :municipalities do |t|
      t.string :name
      t.integer :code
      t.references :department, foreign_key: true
      t.integer :code_department

      t.timestamps
    end
  end
end
