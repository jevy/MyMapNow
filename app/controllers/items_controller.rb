class ItemsController < ApplicationController
  
  def index
    respond_to do |format|
      format.html
      format.js do
        render :json => Item.find_in_bounds(params[:southwest].split(','), params[:northeast].split(','))
      end
    end
  end
  
end
