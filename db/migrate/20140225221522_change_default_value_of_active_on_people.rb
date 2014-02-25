class ChangeDefaultValueOfActiveOnPeople < ActiveRecord::Migration
  def change
    change_column :people, :active, :boolean, null: false, default: true
  end
end
