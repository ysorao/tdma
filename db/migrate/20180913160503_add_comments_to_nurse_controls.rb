class AddCommentsToNurseControls < ActiveRecord::Migration[5.1]
  def change
    add_column :nurse_controls, :commentation, :text
  end
end
