class MapsController < ApplicationController
  before_filter :set_facebook_session
  helper_method :facebook_session

  def facebook_login
    puts facebook_session.user.events
    redirect_to :root
  end
  
end
