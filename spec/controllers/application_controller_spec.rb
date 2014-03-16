require 'spec_helper'

describe ApplicationController do

  controller do
    def index
      render nothing: true
    end
  end

  context 'with invitation query string' do
    context 'logged out' do
      it 'saves the invitation token in session' do
        get :index, invitation: 'abc'
        expect(session[:invitation_token]).to eq 'abc'
      end

      it 'leaves invitation token as nil if none is present' do
        get :index
        expect(session[:invitation_token]).to be_nil
      end
    end

    context 'logged in' do
      before do
        @alice = create :person
        @project = create :project, created_by: @alice.id
        @invitation = create :invitation, email: @alice.email
        @invitation.projects << @project
      end

      it 'adds person to the invited project' do
        get :index, invitation: @invitation.token
        expect(@alice.projects).to include(@project)
      end
    end
  end

end
