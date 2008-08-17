class SearchController < ApplicationController
  
  # search for everything
  def index
    #@posts = Post.find(:all, :conditions => ["text LIKE ? or title LIKE ?", search_query, search_query])
    @users = User.search(params[:search_query])
    @projects = Project.search(params[:search_query])
  end
  
  # search for projects
  def projects
    redirect_back_or_default(:controller => "projects") unless params[:id]
    
    # if weird letter given, go back
    if params[:id].to_i > 0
      begin
        redirect_back_or_default :controller => "projects"
      ensure
          # show error-message whatsoever
          flash[:error] = "'#{params[:id]}' #{l :is_not_a_letter}"
      end
    end
    
      # otherwhise everything seems to be ok
      # letter is there, so lets go:
      @projects = Project.search_first_letters(params[:id])
  end
  
end
