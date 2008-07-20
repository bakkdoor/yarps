class AccountController < ApplicationController
  
  before_filter :login_required, :except => [:login, :signup] # alle methoden außer login/signup brauchen login, da wir im account-controller sind...
  
  # say something nice, you goof!  something sweet.
  def index
    if ((not logged_in?) && User.count == 0)
      redirect_to :action => 'signup'
    elsif(not logged_in?)
      redirect_to :action => 'login'
    end
    
    @last_login = session[:last_login] ? session[:last_login] : Time.now
      
      #TODO hier evtl. dann daten rausholen, die sich seit letztem login geändert haben (Posts, Aufgaben usw...)
    @project_memberships = current_user.project_memberships
  end
  
  
  # account settings
  def settings
      @project_memberships = current_user.project_memberships
      @projects = current_user.projects
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
  
  #######################################
  # => Login/logout spezifische actions #
  #######################################
  
  def login
    if User.count == 0
      redirect_to :action => "signup"
    else  
      return unless request.post?
      self.current_user = User.authenticate(params[:login], params[:password])
      if logged_in?
        if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end
        
        last_login = self.current_user.last_login
        failed_logins = self.current_user.failed_logins
        self.current_user.last_login = Time.now
        self.current_user.failed_logins = 0 # zurücksetzen, da jetzt erfolgreich eingeloggt.
        self.current_user.save
        
        last_login ||= Time.now
          
        session[:last_login] = last_login
        
        if failed_logins && failed_logins > 0
          flash[:error] = "#{l :failed_logins}: #{failed_logins}"
        end
        
        redirect_back_or_default(:controller => '/account', :action => 'index')
        flash[:notice] = (l :login_successful_notice)
      else
        flash[:error] = (l :login_failed_error)
        failed_user = User.find_by_login(params[:login])
        if failed_user
          failed_user.failed_logins += 1
          failed_user.save
        end
      end
    end
  end

  def signup
    #if User.count > 0 then
      #redirect_to :action => "login"
    #else 
      begin
        @user = User.new(params[:user])
        return unless request.post?
        @user.save!
        self.current_user = @user
        redirect_back_or_default(:controller => '/account', :action => 'index')
        flash[:notice] = (l :signup_successful_notice)
      
      rescue ActiveRecord::RecordInvalid
        render :action => 'signup'
      end
    #end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = (l :logout_successful_notice)
    redirect_back_or_default(:controller => '/', :action => 'index')
  end
  
end
