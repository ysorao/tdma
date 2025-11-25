class AddCommentsToImagesInjuries < ActiveRecord::Migration[5.1]
  def change
    add_column :images_injuries, :commentations, :text
  end
end
