class PeopleProjects < ActiveRecord::Migration
  def up
  	create_table :people_projects, :id => false do |t|
      t.integer :person_id
      t.integer :project_id
    end
  end

  def down
  	drop_table :people_projects
  end
end
