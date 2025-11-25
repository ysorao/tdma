class CreateSubsidiaries < ActiveRecord::Migration[5.1]
  def change
    create_table :subsidiaries do |t|
      t.string :name
      t.string :identification
      t.string :address
      t.integer :type_subs
      t.string :code_sds
      t.string :post_code
      t.string :email
      t.string :phone_one
      t.string :phone_two
      t.references :client, foreign_key: true
      t.references :kit, foreign_key: true
      t.references :municipality, foreign_key: true

      t.timestamps
    end
  end
end

20180903213236