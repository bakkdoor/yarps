require 'test_helper'

class MessagesControllerTest < ActionController::TestCase
  
  fixtures :users
  
  def setup
    @controller = MessagesController.new
  end
  
  def test_should_get_index
=begin
    get :index
    assert_response :success
    assert_not_nil assigns(:messages)
=end
  end

  def test_should_get_new
=begin
    get :new
    assert_response :success
=end
  end

  def test_should_create_message
=begin
    assert_difference('Message.count') do
      post :create, :message => { :title => "mytitle", :body => "hey, what's up?", :author_id => 1, :receiver_id => 2 }
    end
    assert_redirected_to message_path(assigns(:message))
=end
  end

  def test_should_show_message
=begin
    get :show, :id => messages(:quentin_to_aaron).id
    assert_response :success
=end
  end

  def test_should_get_edit
=begin
    get :edit, :id => messages(:quentin_to_aaron).id
    assert_response :success
=end
  end

  def test_should_update_message
=begin
    put :update, :id => messages(:quentin_to_aaron).id, :message => { }
    assert_redirected_to message_path(assigns(:message))
=end
  end

  def test_should_destroy_message
=begin
    assert_difference('Message.count', -1) do
      delete :destroy, :id => messages(:quentin_to_aaron).id
    end

    assert_redirected_to messages_path
=end
  end
end
