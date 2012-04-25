class WeeklyDigest < ActionMailer::Base
  def weekly_digest(project)
    @project = project
    for person in @project.people do 
    	@person = person
    	mail(:to => @person.email, :from => "#{@project.name}.weekly_update@offbott.com", :subject => "#{@project.name} Weekly Update")
    end
  end
end
