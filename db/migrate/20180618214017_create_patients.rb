class CreatePatients < ActiveRecord::Migration[5.1]
  def change
    create_table :patients do |t| 
      t.integer :type_document
      t.integer :type_condition
      t.string :number_document
      t.string :name
      t.string :second_name
      t.string :last_name
      t.string :second_surname
      t.date :birthdate
      t.integer :genre
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
