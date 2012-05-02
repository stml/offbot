class WeeklyDigest < ActionMailer::Base
	default :from => "weeklyupdate@#{DOMAIN}"
	def weekly_digest(project, person)
		@project = project
		@from = "#{@project.name.gsub(' ', '')}.weeklyupdate@#{DOMAIN}"
		@person = person
		mail(:to => @person.email, :from => @from, :subject => "#{@project.name} Weekly Update")
	end
end
