class AccountController < ApplicationController
  
  # all methods except login/signup need a valid login, since we are in the account-controller
  before_filter :login_required, :except => [:login, :signup] 
  
  def index
    if ((not logged_in?) && User.count == 0)
      redirect_to :action => 'signup'
    elsif(not logged_in?)
      redirect_to :action => 'login'
    end
    
    @last_login = session[:last_login] || Time.now
     
    #TODO get stuff, that has changed since last login (Posts, Tasks etc...)
    @project_memberships = current_user.project_memberships
    @changed_projects = current_user.changed_projects_since(@last_login)
  end
  
  
  # account settings
  def settings
  end
  
  # GET /account/edit
  def edit
      @user = current_user
  end
  
  # PUT /account/
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = (l :account_successful_update_notice)
        format.html { redirect_to :action => "index" }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
end
