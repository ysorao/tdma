class AddArchivedToConsultations < ActiveRecord::Migration[5.1]
  def change
    add_column :consultations, :archived, :boolean, default: false
  end
end
