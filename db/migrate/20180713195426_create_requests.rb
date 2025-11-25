class CreateRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :requests do |t|
      t.string :comment
      t.integer :type_request
      t.references :consultation, foreign_key: true
      t.integer :specialist_id
      t.integer :doctor_id
      t.string :audio_request
      t.string :description_request
      t.integer :status
      t.timestamps
    end
    add_index :requests, :specialist_id
    add_index :requests, :doctor_id
  end
end
