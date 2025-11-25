class ChangeLimitColumn < ActiveRecord::Migration[5.1]
  def change
  	change_column :clients, :code_service_provider, :integer, limit: 8
  end
end
