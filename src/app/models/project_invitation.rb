class ProjectInvitation < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :project
  
  validates_presence_of :user_id
  validates_presence_of :project_id
  
  # returns a default message for project_invitations
  # if no project_name or invitor_name are given, they are left out of the message
  # otherwhise, they are included
  # the invited user will nevertheless be able to see which project he is invited to
  # but not who invited him, if no invitor_name is given
  def self.default_message(project_name = nil, invitor_name = nil)
    if project_name && invitor_name
      "You have been invited to the following project: #{project_name} by #{invitor_name}"
    elsif project_name && !invitor_name
      "You have been invited to the following project: #{project.name}"
    else
      "You have been invited to the following project:"
    end
  end
  
  # indicates, if project_invitation is viewable by a given user
  def viewable_by?(user)
    self.user == user
  end
  
end
