class AddFieldToAppVersions < ActiveRecord::Migration[5.1]
  def change
    add_column :app_versions, :description, :string
  end
end
