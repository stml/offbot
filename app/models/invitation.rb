class Invitation < ActiveRecord::Base
	attr_accessible :email
	has_and_belongs_to_many :projects
	validates_presence_of :email

	after_create :send_out_invite
	after_update :send_out_invite

	private
	
	def send_out_invite
		SendInvitation.send_out_invite(self).deliver
	end
end
