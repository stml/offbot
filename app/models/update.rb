class Update < ActiveRecord::Base
  attr_accessible :body, :person_id, :project_id
  belongs_to :person
  belongs_to :project
  validates_presence_of :body

  after_create :extract_tags

  acts_as_taggable

  def viewable_by?(person)
    self.project.people.include?(person)
  end

  def editable_by?(person)
    self.person == person or person.is_superadmin? or self.project.project_admins_list.people.include?(person)
  end

  include Twitter::Extractor
  def extract_tags
    tags = extract_hashtags(self.body)
    self.tag_list = tags
  end
end
