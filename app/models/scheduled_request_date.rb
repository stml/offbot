class ScheduledRequestDate < ActiveRecord::Base
  belongs_to :person
  belongs_to :project
  attr_accessible :request_date
end
