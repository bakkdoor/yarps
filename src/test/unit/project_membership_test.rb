require 'test_helper'

class ProjectMembershipTest < ActiveSupport::TestCase
  fixtures :project_memberships
  
  def test_timestamps
    membership = project_memberships(:quentins_membership)
    assert(membership.created_at <= membership.updated_at, "membership.updated_at should be greater/equal than membership.created_at!")
  end
  
  def test_memberships
    membership = project_memberships(:quentins_membership)
    project = membership.project
    users_without_memberships = User.find(:all).select do |user|
      user.projects.all? { |p| p.id != project.id }
    end
    
    assert(membership.created_at <= membership.updated_at, "membership.updated_at should be greater/equal than membership.created_at!")
    assert(membership.project.viewable_by?(membership.user), "User should be able to view project!")
    
    users_without_memberships.each do |user|
      assert(!project.viewable_by?(user), "User shouldn't be able to view project!")
      ProjectMembership.create(:user_id => user.id, :project_id => project.id)
      assert(project.viewable_by?(user), "User should now be able to view project!")
    end
  end
  
end
