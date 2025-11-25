class CreateDiseases < ActiveRecord::Migration[5.1]
  def change
    create_table :diseases do |t|
      t.string :name
      t.string :code
      t.string :limited_sex
      t.string :lower_limit_age
      t.string :upper_limit_age

      t.timestamps
    end
  end
end
