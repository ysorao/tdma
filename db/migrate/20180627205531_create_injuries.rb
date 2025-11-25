class CreateInjuries < ActiveRecord::Migration[5.1]
  def change
    create_table :injuries do |t|
      t.string :name
      t.references :consultation, foreign_key: true
      t.references :body_area, foreign_key: true
      t.references :consultation_control, foreign_key: true

      t.timestamps
    end
  end
end
