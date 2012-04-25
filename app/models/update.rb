class Update < ActiveRecord::Base
  attr_accessible :body, :person_id, :project_id
  belongs_to :person
  belongs_to :project
  validates_presence_of :body

  def viewable_by?(person)
    project = self.project.people.include?(person)
  end

  def editable_by?(person)
    self.person == person or person.is_superadmin? or self.project.project_admins_list.people.include?(person)
  end
end
