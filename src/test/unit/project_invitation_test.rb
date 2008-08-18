require 'test_helper'

class ProjectInvitationTest < ActiveSupport::TestCase
  fixtures :users
  fixtures :project_invitations
  fixtures :projects 
  
  def test_viewable_by_correct_user
    chris = users(:chris)
    aaron = users(:aaron)
    quentin = users(:quentin)
    inv = project_invitations(:inv_for_chris)
    
    assert(inv.viewable_by?(chris), "ProjectInvitation not viewable by user!")
    assert(!inv.viewable_by?(aaron) && !inv.viewable_by?(quentin), "ProjectInvitation viewable by wrong users!")
  end
  
  def test_invitation_to_project
    chris = users(:chris)
    inv = project_invitations(:inv_for_chris)
    project = projects(:project_with_inv_for_chris)
    assert(chris.has_invitation_for?(project), "User should have an invitation to project!")
    assert(chris.can_join?(project), "User should be able to join project!")
    chris.join(project)
    assert(!chris.has_invitation_for?(project), "User shouldn't have an invitation anymore!")
  end
  
  def test_invite_user
    quentin = users(:quentin)
    aaron = users(:aaron)
    chris = users(:chris)
    aarons_project = project_memberships(:aarons_membership).project
    
    assert(!quentin.can_join?(aarons_project), "User shouldn't be able to join project!")
    assert(!quentin.has_invitation_for?(aarons_project), "User shouldn't have an invitation to project!")
    assert(!aarons_project.viewable_by?(quentin), "Failure message.")
    assert(aarons_project.viewable_by?(aaron), "Failure message.")
    assert(aaron.can_invite_users_to_project?(aarons_project), "User should be able to invite users to project (is admin - level_code 100)!")
    assert(!quentin.can_invite_users_to_project?(aarons_project), "User shouldn't be able to invite users to project (no project_membership)!")
    assert(chris.can_invite_users_to_project?(aarons_project), "User should be able to invite users to project (is project_manager)!")
    
    aaron.invite_user_to_project(quentin, aarons_project)    
    
    assert(quentin.has_invitation_for?(aarons_project), "User should have an invitation to project!")
    assert(quentin.can_join?(aarons_project), "User should be able to join project!")
    
    quentin.join(aarons_project)
    
    assert(quentin.projects.include?(aarons_project), "User should be in project by now!")
    assert(aarons_project.viewable_by?(quentin), "User should be able to view project by now!")
  end
  
end
