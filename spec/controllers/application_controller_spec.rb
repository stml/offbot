require 'spec_helper'

describe ApplicationController do

  controller do
    def index
      render nothing: true
    end
  end

  context 'with invitation query string' do
    it 'saves the invitation token in session if not logged in' do
      get :index, invitation: 'abc'
      expect(session[:invitation_token]).to eq 'abc'
    end

    it 'leaves invitation token as nil if none is present' do
      get :index
      expect(session[:invitation_token]).to be_nil
    end
  end

end
