class UsersController < ApplicationController
  
  auto_complete_for :user, :login
  
  # search for user-profiles or so... 
  def index
    @users = User.find(:all)
  end
  
  # profile-page of an account
  def show
    begin
      @profile_user = User.find(params[:id])
    rescue
      flash[:error] = "Profile for UserID '#{params[:id]}' has not been found. "
      redirect_to :controller => "users", :action => "index"  
    end
  end
  
  def auto_complete_for_user_login
    @users = User.find(:all, 
      :conditions => [ 'LOWER(login) LIKE ?',
      '%' + params[:user][:login].downcase + '%' ], 
      :order => 'login ASC',
      :limit => 10)
    render :partial => 'auto_complete_results'
  end
  
end
