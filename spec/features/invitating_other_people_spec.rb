require 'spec_helper'

feature 'inviting other people' do
  include TimedTaskHelpers

  before do
    Timecop.travel(2014, 2, 24, 8, 00) # A Monday at 8:00am
    @owner = create :person
    @project = create :project, created_by: @owner.id
    @email_address = 'invitee@example.com'
    login_as(@owner, scope: :person)
    visit project_path(@project)
    click_on ('Edit this project')
    all('#emails_')[0].set(@email_address)
    click_on('Save this project')
  end

  scenario 'person invites someone to a project and an invite email is sent'  do
    open_email(@email_address)
    expect(current_email.subject).to eq 'Hi! Someone invited you to join Offbott'
  end

  scenario 'person invites someone to a project and they join'  do
    sign_up_from_invite_email

    invitee = Person.find_by_email(@email_address)
    expect(@project.people).to include(invitee)
    expect(invitee.active).to eq true
  end

  scenario 'person invites someone to a project and they join with a different email address'  do
    sign_up_from_invite_email_with_a_different_email

    invitee = Person.find_by_email('max@invitee.com')
    expect(@project.people).to include(invitee)
    expect(invitee.active).to eq true
  end


  scenario 'person invites someone to a project, they join, both get update request email'  do
    Timecop.travel(2014, 2, 24, 8, 01) # A Monday at 8:01am
    sign_up_from_invite_email
    start_time = Time.now
    end_time = start_time + 24.hours
    emails = scheduled_emails_sent_between(start_time, end_time).select { |email| email.subject == "[#{@project.name}] Hello, it's Offbott again" }
    expect(emails).to have(2).messages
  end

  def sign_up_from_invite_email
    open_email(@email_address)
    current_email.click_on('sign up to Offbott.com')
    ActionMailer::Base.deliveries.clear
    click_on('register a new account')
    fill_in('Name', with: 'Max Invitee')
    fill_in('Email', with: @email_address)
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password')
    click_on('Sign up')
  end

  def sign_up_from_invite_email_with_a_different_email
    open_email(@email_address)
    current_email.click_on('sign up to Offbott.com')
    ActionMailer::Base.deliveries.clear
    click_on('register a new account')
    fill_in('Name', with: 'Max Invitee')
    fill_in('Email', with: 'max@invitee.com')
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password')
    click_on('Sign up')
  end
end
