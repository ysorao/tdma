class CreateSpecialistResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :specialist_responses do |t|
      t.string :control_recommended
      t.integer :specialist_id
      t.references :consultation, foreign_key: true
      t.references :consultation_control, foreign_key: true
      t.boolean :sms_send
      t.boolean :mail_send
      t.string :case_analysis
      t.string :analysis_description
      

      t.timestamps
    end
    add_index :specialist_responses, :specialist_id
  end
end
