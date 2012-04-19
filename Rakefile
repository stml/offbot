#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :cron => :environment do
	#Pony.mail(:to => 'james@shorttermmemoryloss.com', :from => "offbot@bot.com", :subject => "Hi", :body => "I am sentient", :via => :smtp)
	time = Time.now.hour
	time_left = 17 - time
	date = Date.today
	Project.all.each do |project|
		#puts project
		project.people.each do |person|
			message = person.email_messages.today.first
			unless message
				email = EmailMessage.new
				email.person = person
				email.project = project
				email.save
			end
		end
	end
end

