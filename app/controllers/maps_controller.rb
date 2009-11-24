class MapsController < ApplicationController

  def facebook_login
    puts facebook_session.user.events
    redirect_to :root
  end
  
end
