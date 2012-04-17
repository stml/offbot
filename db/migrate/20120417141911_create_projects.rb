class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :person_id
      t.integer :update_id

      t.timestamps
    end
  end
end
