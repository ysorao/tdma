class CreateSystemManuals < ActiveRecord::Migration[5.1]
  def change
    create_table :system_manuals do |t|
      t.string :name
      t.string :file_manual
      t.integer :type_manual

      t.timestamps
    end
  end
end
