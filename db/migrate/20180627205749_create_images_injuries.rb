class CreateImagesInjuries < ActiveRecord::Migration[5.1]
  def change
    create_table :images_injuries do |t|
      t.string :photo
      t.text :description
      t.references :injury, foreign_key: true
      t.string :edited_photo

      t.timestamps
    end
  end
end
