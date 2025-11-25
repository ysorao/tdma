class CreateIpsInsurances < ActiveRecord::Migration[5.1]
  def change
    create_table :ips_insurances do |t|
      t.references :client, foreign_key: true
      t.references :insurance, foreign_key: true

      t.timestamps
    end
  end
end
