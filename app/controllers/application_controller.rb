class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mailer_set_url_options
  before_filter :remeber_invitation_token
  before_filter :authenticate_person!
  before_filter :process_invites

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

  # Pass in a string, will raise an Encoding::InvalidByteSequenceError
  # if it contains an invalid byte for it's encoding; otherwise
  # returns an equivalent string.
  #
  # OR, like String#encode, pass in option `:invalid => :replace`
  # to replace invalid bytes with a replacement string in the
  # returned string.  Pass in the
  # char you'd like with option `:replace`, or will, like String#encode
  # use the unicode replacement char if it thinks it's a unicode encoding,
  # else ascii '?'.
  #
  # in any case, method will raise, or return a new string
  # that is #valid_encoding?
  def validate_encoding(str, options = {})
    str.chars.collect do |c|
      if c.valid_encoding?
        c
      else
        unless options[:invalid] == :replace
          # it ought to be filled out with all the metadata
          # this exception usually has, but what a pain!
          # Why isn't ruby doing this for us?
          raise  Encoding::InvalidByteSequenceError.new
        else
          options[:replace] || (
           # surely there's a better way to tell if
           # an encoding is a 'Unicode encoding form'
           # than this? What's wrong with you ruby 1.9?
           str.encoding.name.start_with?('UTF') ?
              "\uFFFD" :
              "?" )
        end
      end
    end.join
  end

  def process_invites
    if person_signed_in? and invitation_token and invitation = Invitation.find_by_token(invitation_token)
      add_current_person_to_invite_projects(invitation)
    elsif person_signed_in? and invitation = Invitation.find_by_email(current_person.email)
      add_current_person_to_invite_projects(invitation)
    end
  end

  def remeber_invitation_token
    if params[:invitation]
      session[:invitation_token] = params[:invitation]
    end
  end

  def invitation_token
    params[:invitation]
  end

  def add_current_person_to_invite_projects(invitation)
    invitation.projects.select {|p| !current_person.projects.include?(p) }.map {|p| current_person.projects << p }
  end
end
