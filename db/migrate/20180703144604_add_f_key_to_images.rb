class AddFKeyToImages < ActiveRecord::Migration[5.1]
  def change
    add_reference :images_injuries, :medical_control, foreign_key: true
  end
end
