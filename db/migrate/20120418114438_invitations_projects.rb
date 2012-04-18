class InvitationsProjects < ActiveRecord::Migration
  def up
  	create_table :invitations_projects, :id => false do |t|
      t.integer :invitation_id
      t.integer :project_id
    end
  end

  def down
  	drop_table :invitations_projects
  end
end
