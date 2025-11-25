class AddFieldToImagesInjury < ActiveRecord::Migration[5.1]
  def change
    add_column :images_injuries, :image_injury_id, :integer
  end
end
