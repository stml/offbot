class EmailMessage < ActiveRecord::Base
  attr_accessible :message_id, :person_id, :project_id, :response_timestap
  has_one :update
  belongs_to :person, :project
end
