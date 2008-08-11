require 'test_helper'

class ProjectMembershipsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:project_memberships)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_project_membership
    assert_difference('ProjectMembership.count') do
      post :create, :project_membership => { }
    end

    assert_redirected_to project_membership_path(assigns(:project_membership))
  end

  def test_should_show_project_membership
    get :show, :id => project_memberships(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => project_memberships(:one).id
    assert_response :success
  end

  def test_should_update_project_membership
    put :update, :id => project_memberships(:one).id, :project_membership => { }
    assert_redirected_to project_membership_path(assigns(:project_membership))
  end

  def test_should_destroy_project_membership
    assert_difference('ProjectMembership.count', -1) do
      delete :destroy, :id => project_memberships(:one).id
    end

    assert_redirected_to project_memberships_path
  end
end
