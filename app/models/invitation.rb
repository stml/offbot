class Invitation < ActiveRecord::Base
	attr_accessible :email
	has_and_belongs_to_many :projects
	validates_presence_of :email

	after_create :add_to_projects

	private

	def add_to_projects
		invitation = Invitation.find_by_email(self.email)
			if invitation	
				invitation.projects.each do |project|
				self.projects << project	
			end
		end	
	end
end
