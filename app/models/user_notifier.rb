class UserNotifier < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://people.limewire.com/users/#{user.login};activate?activation_code=#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://people.limewire.com/"
  end

  def forgot_password(user)
     setup_email(user)
     @subject    += 'Request to change your password'
     @body[:url]  = "http://people.limewire.com/reset/#{user.password_reset_code}"
   end

   def reset_password(user)
     setup_email(user)
     @subject    += 'Your password has been reset'
   end

  protected
  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "mnutt@limewire.com"
    @subject     = "[lime directory] "
    @sent_on     = Time.now
    @body[:user] = user
  end
end
