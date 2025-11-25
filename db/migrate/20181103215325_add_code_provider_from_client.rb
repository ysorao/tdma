class AddCodeProviderFromClient < ActiveRecord::Migration[5.1]
  def change
    add_column :clients, :code_service_provider, :integer
  end
end
