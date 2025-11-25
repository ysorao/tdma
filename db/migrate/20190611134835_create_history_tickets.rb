class CreateHistoryTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :history_tickets do |t|
      t.string :message_create
      t.string :message_assign
      t.string :message_response
      t.references :help_desk, foreign_key: true

      t.timestamps
    end
  end
end
