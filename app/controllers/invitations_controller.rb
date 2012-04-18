class InvitationsController < ApplicationController
  
  private

  def new
    @invitation = Invitation.new
  end


end
