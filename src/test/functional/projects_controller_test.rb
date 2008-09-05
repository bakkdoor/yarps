require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
=begin
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:projects)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_project
    assert_difference('project.count') do
      post :create, :project => { }
    end

    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_show_project
    get :show, :id => projects(:non_private_and_none_invite_only).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => projects(:non_private_and_none_invite_only).id
    assert_response :success
  end

  def test_should_update_project
    put :update, :id => projects(:non_private_and_none_invite_only).id, :project => { }
    assert_redirected_to project_path(assigns(:project))
  end

  def test_should_destroy_project
    assert_difference('project.count', -1) do
      delete :destroy, :id => projects(:non_private_and_none_invite_only).id
    end

    assert_redirected_to projects_path
  end
=end
end
