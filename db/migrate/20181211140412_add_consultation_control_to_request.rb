class AddConsultationControlToRequest < ActiveRecord::Migration[5.1]
  def change
    add_reference :requests, :consultation_control, foreign_key: true
  end
end
