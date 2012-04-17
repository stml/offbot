class AddProjectIdToUpdate < ActiveRecord::Migration
  def change
    add_column :updates, :project_id, :integer
  end
end
