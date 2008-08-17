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
  
end
