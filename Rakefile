#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :cron => :environment do
	# send out update requests
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
					sleep(2.minutes)
				end
			end
		end
	end

	# send out weekly digest 
	if Time.now.hour == 17
		todays_digests = Project.where(:weekly_digest_day => (Date.parse(Date.today.to_s).strftime("%A")))
		todays_digests.each do |project|
			unless Date.parse(project.last_weekly_digest_sent_at) == Date.today
				project.people.each do |person|
					WeeklyDigest.weekly_digest(project, person).deliver
				end
				project.last_weekly_digest_sent_at = DateTime.now
				project.save
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
			Regexp.new("On\s.*,\s.*offbott.com\swrote:.*", Regexp::IGNORECASE | Regexp::MULTILINE),
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

desc "Send out weekly digest"
task :send_out_weekly_digest => :environment do
	todays_digests = Project.where(:weekly_digest_day => (Date.parse(Date.today.to_s).strftime("%A")))
	todays_digests.each do |project|
		project.people.each do |person|
			WeeklyDigest.weekly_digest(project, person).deliver
		end
	end
end

