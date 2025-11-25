class AddCommentsToFormulas < ActiveRecord::Migration[5.1]
  def change
    add_column :formulas, :commentations, :text
  end
end
