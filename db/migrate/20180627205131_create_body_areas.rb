class CreateBodyAreas < ActiveRecord::Migration[5.1]
  def change
    create_table :body_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
