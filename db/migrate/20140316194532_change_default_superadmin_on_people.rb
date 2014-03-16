class ChangeDefaultSuperadminOnPeople < ActiveRecord::Migration
  def change
    change_column_default :people, :is_superadmin, false
  end
end
