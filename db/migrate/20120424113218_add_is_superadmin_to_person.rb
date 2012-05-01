class AddIsSuperadminToPerson < ActiveRecord::Migration
  def change
    add_column :people, :is_superadmin, :boolean
  end
end
