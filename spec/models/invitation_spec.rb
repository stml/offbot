require 'spec_helper'

describe Invitation do
  it 'should require an email' do
    invitation = Invitation.new(email: nil)
    expect(invitation).to_not be_valid
  end

  it 'generates a token' do
    invitation = Invitation.create(email: 'hello@offbott.com')
    expect(invitation.token).to_not be_nil
  end
end
