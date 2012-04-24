#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :cron => :environment do
	#Pony.mail(:to => 'james@shorttermmemoryloss.com', :from => "offbot@bot.com", :subject => "Hi", :body => "I am sentient", :via => :smtp)
	time = Time.now.hour
	if (9..17).member?(time)
		time_left = 17 - time
		date = Date.today
		Project.all.each do |project|
			project.people.each do |person|
				message = person.email_messages.today_on_project(project).first
				unless message
					random_number = rand(time_left) + 1
					puts  "Likelihood of sending out the update request for #{person.name} on project #{project.name}: 1/#{random_number}"
					Rails.logger.info "Likelihood of sending out the update request for #{person.name} on project #{project.name}: 1/#{random_number}"
					if random_number.to_i === 1
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

task :extract_reply => :environment do
	def extract_reply(text, address)
		regex_arr = [
			Regexp.new("From:\s*" + Regexp.escape(address), Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("<" + Regexp.escape(address) + ">", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new(Regexp.escape(address) + "\s+wrote:", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("^.*On.*(\n)?wrote:$", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("\s\S*On\s\w*.\s.*", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("On\s.*,", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("-+original\s+message-+\s*$", Regexp::IGNORECASE | Regexp::MULTILINE),
			Regexp.new("from:\s*$", Regexp::IGNORECASE | Regexp::MULTILINE)
		]

		text_length = text.length
		#calculates the matching regex closest to top of page
		index = regex_arr.inject(text_length) do |min, regex|
			puts min
				[(text.index(regex) || text_length), min].min
		end

		text[0, index].strip
	end

	puts extract_reply(Update.last.body, 'offbott.114cbbb0-6f52-012f-7b02-123139338563@offbott.com')

end

desc "Add project admins list to every project that's missing one"
task :add_project_admins_list => :environment do
	Project.all.each do |project|
		unless project.add_project_admins_list
			admins_list = ProjectAdminsList.new
			project.project_admins_list = admins_list
			project.save
		end
	end
end

