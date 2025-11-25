class AddFieldsFromHelpDesk < ActiveRecord::Migration[5.1]
  def change
    add_column :help_desks, :subject, :string
    add_column :help_desks, :response_ticket, :string
    add_column :help_desks, :image_user, :string
    add_column :help_desks, :image_admin, :string
    add_reference :help_desks, :admin_user, foreign_key: true
  end
end
