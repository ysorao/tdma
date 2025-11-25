class AddFieldToSpecialistResponses < ActiveRecord::Migration[5.1]
  def change
    add_column :specialist_responses, :nurse_id, :integer
  end
end
