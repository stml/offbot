class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_person!, :mailer_set_url_options

  helper :all

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end


  # let's handle the exceptions
  class NotPermitted < StandardError
  end

  rescue_from NotPermitted, :with => :not_permitted

  def not_permitted(exception)
    redirect_to root_path, :alert => "I'm very sorry, but you can't do this."
  end

end
