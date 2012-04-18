#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Offbot::Application.load_tasks

task :send_email => :environment do
	Pony.mail(:to => 'natalia.buckley@gmail.com', :via => :sendmail)
end
