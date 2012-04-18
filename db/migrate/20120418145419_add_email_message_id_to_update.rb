class AddEmailMessageIdToUpdate < ActiveRecord::Migration
  def change
    add_column :updates, :email_message_id, :integer
  end
end
