class CreatePrepayCards < ActiveRecord::Migration[5.1]
  def change
    create_table :prepay_cards do |t|
      t.string :name
      t.string :description
      t.integer :credits

      t.timestamps
    end
  end
end
