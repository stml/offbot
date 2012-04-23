class AddProjectAdminsListIdToPerson < ActiveRecord::Migration
  def change
    add_column :people, :project_admins_list_id, :integer
  end
end
