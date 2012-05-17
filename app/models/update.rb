class Update < ActiveRecord::Base
  include ActionView::Helpers::TextHelper
  include ActionView::Helpers::SanitizeHelper

  attr_accessible :body, :person_id, :project_id
  belongs_to :person
  belongs_to :project
  validates_presence_of :body

  after_create :extract_tags 
  before_create :sanitise
  before_update :sanitise

  acts_as_taggable

  def viewable_by?(person)
    self.project.people.include?(person)
  end

  def editable_by?(person)
    self.person == person or person.is_superadmin? or self.project.project_admins_list.people.include?(person)
  end

  def sanitise
    self.body = strip_tags(self.body)
  end

  include Twitter::Extractor
  def extract_tags
    tags = extract_hashtags(self.body)
    self.tag_list = tags
  end
end
