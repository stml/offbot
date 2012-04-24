class PagesController < ApplicationController
  skip_before_filter :authenticate_person!
  def about
      respond_to do |format|
      format.html
    end
  end
end