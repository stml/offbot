class RemovePersonIdAndUpdateIdFromProject < ActiveRecord::Migration
  def up
  	remove_column :projects, :person_id
  	remove_column :projects, :update_id
  end

  def down
  end
end
