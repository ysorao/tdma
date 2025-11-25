class ChangeColumnNameVersion < ActiveRecord::Migration[5.1]
  def change
    rename_column :app_versions, :version, :version_movil
  end
end
