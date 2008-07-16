class UsersController < ApplicationController
  
  # nach profile von usern suchen oder so...
  def index
    
  end
  
  # profilseite eines accounts
  def show
    @profile_user = User.find_by_login(params[:username])
    
    # falls user nicht gefunden, auf eigenes profil weiterleiten, falls eingeloggt
    # ansonsten auf startseite...
    if not @profile_user
      flash[:error] = "Profile for User '#{params[:username]}' has not been found. "
      if logged_in?
        flash[:error] +=  "Redirected to own profile."
        redirect_to :action => "show", :username => current_user.login
      else
        redirect_to :controller => "profiles", :action => "index"
      end
    end
  end
  
end
