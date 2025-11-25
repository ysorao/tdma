class CreateDesignedResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :designed_responses do |t|
      t.string :title
      t.string :description
      t.integer :status

      t.timestamps
    end
  end
end
