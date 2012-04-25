class WeeklyDigest < ActionMailer::Base
	default :from => "weeklyupdate@offbott.com"
	def weekly_digest(project, person)
		@project = project
		@from = "#{@project.name.gsub(' ', '')}.weeklyupdate@offbott.com"
		@person = person
		mail(:to => @person.email, :from => @from, :subject => "#{@project.name} Weekly Update")
	end
end
