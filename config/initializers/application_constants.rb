if [RAILS_ENV] == production
	DOMAIN = "offbott.com"
elsif [RAILS_ENV] == staging
	DOMAIN = "staging.offbott.com"
end