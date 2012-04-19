class Update < ActiveRecord::Base
  attr_accessible :body, :person_id, :project_id
  belongs_to :person
  belongs_to :project
  validates_presence_of :body
end
