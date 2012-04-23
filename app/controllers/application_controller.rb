class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_person!, :mailer_set_url_options

  helper :all

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  def current_ability
	  @current_ability ||= AccountAbility.new(current_person)
	end
end
