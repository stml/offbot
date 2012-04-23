class CreateProjectAdminsLists < ActiveRecord::Migration
  def change
    create_table :project_admins_lists do |t|
      t.integer :project_id

      t.timestamps
    end
  end
end
