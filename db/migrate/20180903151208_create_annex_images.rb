class CreateAnnexImages < ActiveRecord::Migration[5.1]
  def change
    create_table :annex_images do |t|
      t.string :annex_url
      t.references :consultation, foreign_key: true
      t.references :consultation_control, foreign_key: true

      t.timestamps
    end
  end
end
