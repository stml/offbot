require 'spec_helper'

feature 'inviting other people' do

  before do
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

  def sign_up_from_invite_email
    open_email(@email_address)
    current_email.click_on('Offbott.com')
    ActionMailer::Base.deliveries.clear
    click_on('register a new account')
    fill_in('Name', with: 'Max Invitee')
    fill_in('Email', with: @email_address)
    fill_in('Password', with: 'password')
    fill_in('Password confirmation', with: 'password')
    click_on('Sign up')

    open_email(@email_address)
    current_email.click_on('Confirm my Offbott account')
  end

end
