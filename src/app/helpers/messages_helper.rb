module MessagesHelper
  
  def reply_message(old_message)
    new_message = " \n\n------------------------\n#{old_message.author.login} wrote (#{old_message.created_at.format(:language => current_language, :format => :long)}):\n_#{old_message.body}_"
  end
  
end
