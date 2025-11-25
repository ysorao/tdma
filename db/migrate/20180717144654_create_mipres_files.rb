class CreateMipresFiles < ActiveRecord::Migration[5.1]
  def change
    create_table :mipres_files do |t|
      t.string :mipres
      t.references :specialist_response, foreign_key: true

      t.timestamps
    end
  end
end
