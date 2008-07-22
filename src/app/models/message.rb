class Message < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :body
  validates_presence_of :author_id
  validates_presence_of :receiver_id
  
  def receiver
    User.find(self.receiver_id)
  end
  
  def author
    User.find(self.author_id)
  end
  
end
