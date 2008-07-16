class SearchController < ApplicationController
  
  # nach allem suchen
  def index
    #@posts = Post.find(:all, :conditions => ["text LIKE ? or title LIKE ?", search_query, search_query])
    @users = User.search(params[:search_query])
    @teams = Team.search(params[:search_query])
  end
  
  # nach teams suchen
  def teams
    redirect_back_or_default(:controller => "teams") unless params[:id]
    
    # falls komischer buchstabe angegeben, gehe zurück
    if params[:id].to_i > 0
      begin
        redirect_back_or_default :controller => "teams"
      ensure
          # auf jeden fall fehlermeldung ausgeben
          flash[:error] = "'#{params[:id]}' #{l :is_not_a_letter}"
      end
    end
    
      # ansonsten scheint alles ok verlaufen zu sein
      # buchstabe ist da, also los:
      @teams = Team.search_first_letters(params[:id])
  end
  
end
