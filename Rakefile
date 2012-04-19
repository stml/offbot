#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :cron => :environment do
	#Pony.mail(:to => 'james@shorttermmemoryloss.com', :from => "offbot@bot.com", :subject => "Hi", :body => "I am sentient", :via => :smtp)
	time = Time.now.hour
	time_left = 17 - time
	if (9..17).member?(time)
		date = Date.today
		Project.all.each do |project|
			project.people.each do |person|
				message = person.email_messages.on_project(project).today.first
				unless message
					random_number = rand(1..time_left)
					puts "Likelihood of sending out the update request for #{person.name} on project #{project.name}: #{random_number}"
					if random_number === 1
						email = EmailMessage.new
						email.person = person
						email.project = project
						email.save
					end
				end
			end
		end
	end
end

