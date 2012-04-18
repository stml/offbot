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
		project.people.each do |person|
			unless EmailMessage.find(:all, :conditions => { :person => person, :project => project, :created_at => ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day] } )
				email = EmailMessage.new
				email.project = project
				email.person = person
				email.save
				puts email
			end
		end
	end
end

