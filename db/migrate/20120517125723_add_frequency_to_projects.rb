class AddFrequencyToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :frequency, :integer
  end
end
