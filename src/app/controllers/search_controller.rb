class SearchController < ApplicationController
  
  def index
    #@posts = Post.find(:all, :conditions => ["text LIKE ? or title LIKE ?", search_query, search_query])
    @users = User.search(params[:search_query])
    @teams = Team.search(params[:search_query])
  end
  
end
