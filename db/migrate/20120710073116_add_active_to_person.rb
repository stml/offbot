class AddActiveToPerson < ActiveRecord::Migration
  def change
    add_column :people, :active, :boolean
  end
end
