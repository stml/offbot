class ChangeArchivedOnProjects < ActiveRecord::Migration
  def up
    Project.where(archived: nil).each do |project|
      project.archived = false
      project.save!
    end
    change_column :projects, :archived, :boolean, null: false, default: false
  end

  def down
    change_column :projects, :archived, :boolean
  end
end
