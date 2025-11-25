class CreateAppVersions < ActiveRecord::Migration[5.1]
  def change
    create_table :app_versions do |t|
      t.string :apk_file
      t.string :version

      t.timestamps
    end
  end
end
