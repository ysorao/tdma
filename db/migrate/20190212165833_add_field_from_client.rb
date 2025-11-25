class AddFieldFromClient < ActiveRecord::Migration[5.1]
  def change
    add_reference :clients, :municipality, foreign_key: true
  end
end
