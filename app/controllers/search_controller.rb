class SearchController < ApplicationController
  
  def index
      @users = User.look(params[:keyword])
  end
  

  
end
