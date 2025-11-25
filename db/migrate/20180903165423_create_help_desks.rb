class CreateHelpDesks < ActiveRecord::Migration[5.1]
  def change
    create_table :help_desks do |t|
      t.string :description
      t.string :ticket
      t.integer :status
      t.references :user, foreign_key: true
      t.references :device, foreign_key: true

      t.timestamps
    end
  end
end
