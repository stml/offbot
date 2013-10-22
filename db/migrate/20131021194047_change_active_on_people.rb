class ChangeActiveOnPeople < ActiveRecord::Migration
  def up
    Person.where(active: nil).each do |person|
      person.active = true
      person.save!
    end
    change_column :people, :active, :boolean, null: false, default: false
  end

  def down
    change_column :people, :active, :boolean
  end
end
