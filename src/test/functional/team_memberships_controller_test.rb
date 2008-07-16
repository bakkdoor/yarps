require 'test_helper'

class TeamMembershipsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:team_memberships)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_team_membership
    assert_difference('TeamMembership.count') do
      post :create, :team_membership => { }
    end

    assert_redirected_to team_membership_path(assigns(:team_membership))
  end

  def test_should_show_team_membership
    get :show, :id => team_memberships(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => team_memberships(:one).id
    assert_response :success
  end

  def test_should_update_team_membership
    put :update, :id => team_memberships(:one).id, :team_membership => { }
    assert_redirected_to team_membership_path(assigns(:team_membership))
  end

  def test_should_destroy_team_membership
    assert_difference('TeamMembership.count', -1) do
      delete :destroy, :id => team_memberships(:one).id
    end

    assert_redirected_to team_memberships_path
  end
end
