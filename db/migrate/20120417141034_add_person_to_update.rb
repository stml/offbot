class AddPersonToUpdate < ActiveRecord::Migration
  def change
  	add_column :updates, :person_id, :integer
  end
end
