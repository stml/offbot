if ENV["RAILS_ENV"] == "production"
	DOMAIN = "offbott.com"
elsif ENV["RAILS_ENV"] == "staging"
	DOMAIN = "staging.offbott.com"
else
	DOMAIN = "offbott.com"
end