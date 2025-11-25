class CreateRequestImages < ActiveRecord::Migration[5.1]
  def change
    create_table :request_images do |t|
      t.string :image_request
      t.references :request, foreign_key: true

      t.timestamps
    end
  end
end
