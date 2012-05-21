class EmailMessage < ActiveRecord::Base
  attr_accessible :message_id, :person_id, :project_id, :response_timestap, :update_id
  has_one :update
  belongs_to :person
  belongs_to :project

  before_create :generate_message_id
  after_create :send_email_message

  #scope :today, lambda { where('created_at >= ? AND created_at <= ?', Date.today.beginning_of_day, Date.today.end_of_day) }

  def self.today_on_project(passed_project)
	  where('project_id = ? AND created_at >= ? AND created_at <= ?', passed_project.id, Date.today.beginning_of_day, Date.today.end_of_day)
	end

  def self.first_part_of_the_week_on_project(passed_project)
    where('project_id = ? AND created_at >= ? AND created_at <= ?', passed_project.id, Date.today.beginning_of_week.beginning_of_day, Date.today.beginning_of_week.advance(:days => 2).end_of_day)
  end

  def self.second_part_of_the_week_on_project(passed_project)
    where('project_id = ? AND created_at >= ? AND created_at <= ?', passed_project.id, Date.today.beginning_of_week.advance(:days => 3).beginning_of_day, Date.today.beginning_of_week.advance(:days => 4).end_of_day)
  end

  private 

  def generate_message_id
  	uuid = UUID.new
  	self.message_id = uuid.generate.to_s
  end

  def send_email_message
  	RequestUpdate.request_update(self).deliver
  end

end
