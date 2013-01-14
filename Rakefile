#!/usr/bin/env rake

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :cron => :environment do
	time = Time.now.hour
	date = Date.today
	#only on weekdays
	if (1..5).member?(date.wday)
		# only 9 to 5
		if (9..17).member?(time)

		  scheduled_requests = ScheduledRequestDate.where('request_date >= ? AND request_date <= ?', DateTime.now.beginning_of_hour, DateTime.now.end_of_hour)

		  scheduled_requests.uniq.each do |request_date|
		  	ScheduledRequestsMethods.send_update_request(request_date.person, request_date.project)
		  	request_date.destroy
		  end

		 end
	end

	# send out weekly digest 
	if Time.now.hour == 17
		todays_digests = Project.where(:weekly_digest_day => (Date.parse(Date.today.to_s).strftime("%A")))
		unless todays_digests
			todays_digests.each do |project|
				unless Date.parse(project.weekly_digest_sent_at) == Date.today
					project.people.each do |person|
						WeeklyDigest.weekly_digest(project, person).deliver
					end
					project.weekly_digest_sent_at = DateTime.now
					project.save
				end
			end
		end
	end

	# generate schedule on Sundays
	if date.wday == 0 and Time.now.hour == 12
		require "#{Rails.root}/lib/scheduled_requests_methods"
	
		Project.all.each do |project|
			if (project.archived == nil or project.archived == false)
				project.people.each do |person|
					if (person.active == nil or person.active == true)
						# on twice- or once-monthly projects only update the schedule once a month for next month
						if ( (project.frequency == 3 or project.frequency == 4) and ((date.end_of_month-7)..date.end_of_month).member?(date) )
							sunday = Date.today + 7
							dates = ScheduledRequestsMethods.generate_scheduled_dates(project.frequency, sunday)
						elsif (0..2).member?(project.frequency)
							dates = ScheduledRequestsMethods.generate_scheduled_dates(project.frequency)
						elsif project.frequency.nil?
							dates = ScheduledRequestsMethods.generate_scheduled_dates(0)
						end
						if dates
							dates.each do |date|
								ScheduledRequestsMethods.create_scheduled_date(person, project, date)
							end
						end
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

desc "Send out a test update request"
task :test_update_request => :environment do
	email = EmailMessage.new
	email.person = Person.find_by_email("natalia.buckley@gmail.com")
	email.project = Project.find_by_name("Test")
	email.save
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

desc "Generate a schedule"
task :generate_schedule => :environment do
	require "#{Rails.root}/lib/scheduled_requests_methods"
	
	Project.all.each do |project|

		project.people.each do |person|
			# on twice- or once-monthly projects only update the schedule once a month for next month
			if ( (project.frequency == 3 or project.frequency == 4) and ((date.end_of_month-7)..date.end_of_month).member?(date) )
				sunday = Date.today + 7
				dates = ScheduledRequestsMethods.generate_scheduled_dates(project.frequency, sunday)
			elsif (0..2).member?(project.frequency)
				dates = ScheduledRequestsMethods.generate_scheduled_dates(project.frequency)
			elsif project.frequency.nil?
				dates = ScheduledRequestsMethods.generate_scheduled_dates(0)
			end
			if dates
				dates.each do |date|
					ScheduledRequestsMethods.create_scheduled_date(person, project, date)
				end
			end
		end
	end
end

desc 'Remove date duplicates'
task :remove_date_duplicates => :environment do
	ScheduledRequestDate.all.each do |date|
		request_dates = ScheduledRequestDate.where('request_date >= ? AND request_date <= ?', date.request.date.beginning_of_day, date.request.end_of_day)
		puts date
		puts request dates

		if request_dates.length > 1 
			request_dates.each_with_index do |request_date, index|
				if index > 0
					puts request date
					#request_date.destroy
				end
			end
		end
	end
end

