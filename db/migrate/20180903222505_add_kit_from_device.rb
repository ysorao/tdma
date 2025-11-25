class AddKitFromDevice < ActiveRecord::Migration[5.1]
  def change
    add_reference :devices, :kit, foreign_key: true
  end
end
