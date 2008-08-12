class ProjectInvitation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :project
  
  validates_presence_of :user_id
  validates_presence_of :project_id
  
  def self.default_message
    "You have been invited to the following project:"
  end
  
end
