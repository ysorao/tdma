class CreateRequestExams < ActiveRecord::Migration[5.1]
  def change
    create_table :request_exams do |t|
      t.string :name_type_exam
      t.references :specialist_response, foreign_key: true
      t.integer :specialist_id
      t.integer :status

      t.timestamps
    end
    add_index :request_exams, :specialist_id
  end
end
