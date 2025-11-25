class CreateDevices < ActiveRecord::Migration[5.1]
  def change
    create_table :devices do |t|
      t.string :imei
      t.datetime :delivery_date
      t.references :app_version, foreign_key: true

      t.timestamps
    end
  end
end
