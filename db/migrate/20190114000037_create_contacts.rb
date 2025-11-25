class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.string :name_complete
      t.string :email
      t.string :phone
      t.text :message

      t.timestamps
    end
  end
end
