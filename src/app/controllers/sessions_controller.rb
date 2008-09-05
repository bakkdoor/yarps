# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag

      last_login = user.last_login
      user.last_login = Time.now
      user.save
      
      last_login ||= Time.now
        
      session[:last_login] = last_login
      
      if user.failed_logins > 0
        flash[:error] = "#{l :failed_logins}: #{user.failed_logins}"
        user.failed_logins = 0 # reset, since successfully logged in now.
        user.save
      end
      
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = (l :login_successful_notice)
      
    else
      note_failed_signin
      @login       = params[:login]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = (l :logout_successful_notice)
    redirect_back_or_default('/')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    #flash[:error] = "Couldn't log you in as '#{params[:login]}'"
    flash[:error] = (l :login_failed_error)
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
