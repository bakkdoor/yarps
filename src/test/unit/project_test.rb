require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  fixtures :projects
  fixtures :users
  
  def test_invalid_with_empty_attributes
    project = Project.new
    assert !project.valid?
    assert project.errors.invalid?(:name)
    
    project.name = "testname"
    assert project.valid?
  end
  
  def test_name
    assert_equal("Test project one", projects(:non_private_and_none_invite_only).name)
  end
  
  def test_viewable_by_user
    user = users(:aaron)
    project = projects(:public_and_invite_only)
    assert !project.viewable_by?(user)
    
    # set up new invitation => user can now join
    proj_inv = ProjectInvitation.new(:user_id => user.id, :project_id => project.id, :message => "ProjectInvitation test :)")
    proj_inv.save
    
    assert proj_inv.valid?
    assert user.can_join?(project)
    assert user.join(project)
    assert project.viewable_by?(user)
    
  end
  
  def test_user_can_join
    user = users(:aaron)
    project = projects(:public_and_non_invite_only)
    
    assert user.can_join?(project)
    project = projects(:public_and_invite_only)
    assert(!user.can_join?(project), "User shouldn't be able to join project!")
    
    # set up new invitation => user can now join
    proj_inv = ProjectInvitation.new(:user_id => user.id, :project_id => project.id)
    proj_inv.save
    
    assert proj_inv.valid?
    assert user.can_join?(project)
    
  end
  
  def test_changed_projects_since_of_user
    chris = users(:chris)
    
    # create some project-memberships to work with
    ProjectMembership.create(:user_id => chris.id, :project_id => 1)
    ProjectMembership.create(:user_id => chris.id, :project_id => 2)
    ProjectMembership.create(:user_id => chris.id, :project_id => 3)
    
    chris.projects.each_with_index do |p, i|
      p.updated_at = (i*10).minutes.ago
    end
    
    chris.last_login = 25.minutes.ago # simulate last login
    chris.save
    
    assert(chris.last_login, "user.last_login shouldn't be nil!")
    assert_equal(chris.projects.size - 1, chris.changed_projects_since(chris.last_login).size)
    chris.changed_projects_since(chris.last_login).each do |project|
    assert(project.updated_at <= Time.now, "project.updated_at should be smaller/equal than Time.now!")
    end
  end
end
