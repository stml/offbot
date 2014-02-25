require 'spec_helper'

feature 'inviting other people' do

  before do
    @owner = create :person
    @project = create :project, created_by: @owner.id
    @email_address = 'invitee@example.com'
  end

  scenario 'person invites someone to a project and an invite email is sent'  do
    login_as(@owner, scope: :person)
    visit project_path(@project)
    click_on ('Edit this project')
    all('#emails_')[0].set(@email_address)
    click_on('Save this project')

    open_email(@email_address)
    expect(current_email.subject).to eq 'Hi! Someone invited you to join Offbott'
  end

end
