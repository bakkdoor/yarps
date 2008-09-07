class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += (l :please_activate_your_account)
  
    @body[:url]  = "http://#{YARPS_CONFIG['mailer']['domain']}/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += (l :your_account_has_been_activated)
    @body[:url]  = "http://#{YARPS_CONFIG['mailer']['domain']}/"
  end
  
  def forgot_password(user)
      setup_email(user)
      @subject    += (l :you_have_requested_to_change_your_password)
      @body[:url]  = "http://#{YARPS_CONFIG['mailer']['domain']}/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject    += (l :your_password_has_been_reset)
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "#{YARPS_CONFIG['mailer']['from']}"
      @subject     = "[users@YARPS] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
