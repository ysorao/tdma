class CreateLibraryAnalyses < ActiveRecord::Migration[5.1]
  def change
    create_table :library_analyses do |t|
      t.string :name
      t.references :specialist_response, foreign_key: true
      t.integer :type_analysis

      t.timestamps
    end
  end
end
