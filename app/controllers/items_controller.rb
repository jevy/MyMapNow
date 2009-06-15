class ItemsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.js do
        render :json => Item.find(:all)
      end
    end
  end
  
end
