require File.dirname(__FILE__) + '/../test_helper'
require 'account_controller'

# Re-raise errors caught by the controller.
class AccountController; def rescue_action(e) raise e end; end

class AccountControllerTest < Test::Unit::TestCase

  fixtures :users

  def setup
    @controller = AccountController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end


  protected
    def create_user(options = {})
      post :signup, :user => { :login => 'quire', :email => 'quire@example.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
    
    def auth_token(token)
      CGI::Cookie.new('name' => 'auth_token', 'value' => token)
    end
    
    def cookie_for(user)
      auth_token users(user).remember_token
    end
end
