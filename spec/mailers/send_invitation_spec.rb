require 'spec_helper'

describe SendInvitation do
  before do
    @invite = Invitation.create(email: 'hello@offbott.com')
    @email = SendInvitation.send_out_invite(@invite)
  end

  it 'renders correct subject' do
    expect(@email.subject).to eq 'Hi! Someone invited you to join Offbott'
  end

  it 'sends it to the correct recipient' do
    expect(@email.to).to eq ['hello@offbott.com']
  end

  it 'comes from the right sender' do
    expect(@email.from).to eq ["joinoffbott@#{DOMAIN}"]
  end

  it 'has the sign up link that includes the token' do
    expect(@email.body).to have_link('sign up to Offbott.com', href: "http://#{DOMAIN}/?invitation=#{@invite.token}")
  end
end
