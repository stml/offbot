class AddProjectIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :project_id, :integer
  end
end
