class CreateLibrarySpecialists < ActiveRecord::Migration[5.1]
  def change
    create_table :library_specialists do |t|
      t.string :name
      t.references :specialist_response, foreign_key: true
      t.integer :specialist_id
      t.references :formula, foreign_key: true

      t.timestamps
    end
    add_index :library_specialists, :specialist_id
  end
end
