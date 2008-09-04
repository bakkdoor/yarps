require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  fixtures :messages
  fixtures :users
  
  def test_message_readable_by_correct_person
    message = messages(:quentin_to_aaron)
    assert_equal(message.author_id, users(:quentin).id)
    assert_equal(message.receiver_id, users(:aaron).id)
    assert message.readable_by?(users(:quentin))
    assert message.readable_by?(users(:quentin))
    assert !message.readable_by?(users(:chris))
  end
  
  def test_user_can_read_message
    message = messages(:quentin_to_aaron)
    quentin = users(:quentin)
    aaron = users(:aaron)
    chris = users(:chris)
    assert(!chris.can_read_message?(message), "Chris shouldn't be able to read this message!")
    assert(aaron.can_read_message?(message) && quentin.can_read_message?(message), "Users should be able to read message!")
    assert(!message.is_read, "Message shouldn't be read yet!")
    quentin.read_message(message)
    assert(!message.is_read, "Message shouldn't be read yet!")
    aaron.read_message(message)
    assert(message.is_read, "Message should be read by now!")
  end
  
  def test_user_can_delete_message
    message = messages(:quentin_to_aaron)
    quentin = users(:quentin)
    aaron = users(:aaron)
    chris = users(:chris)
    
    assert(quentin.can_delete_message?(message), "Quentin could not delete message.")
    assert(aaron.can_delete_message?(message), "Aaron could not delete message.")
    assert(!chris.can_delete_message?(message), "Chris shouldn't be able to delete message.")
  end
  
  def test_message_deletion
    message = messages(:aaron_to_quentin)
    aaron = users(:aaron)
    quentin = users(:quentin)
    chris = users(:chris)
    
    assert !message.all_deleted?
    assert !chris.can_delete_message?(message)
    assert quentin.can_delete_message?(message)
    assert aaron.can_delete_message?(message)
    
    aaron.delete_message(message)
    assert(!message.all_deleted?, "Messages all deleted, but should not be!")
    quentin.delete_message(message)
    assert(message.all_deleted?, "Not all messages deleted!")
  end
  
  def test_correct_author_and_receiver
    author = users(:chris)
    receiver = users(:aaron)
    message = Message.create(:title => "test", :body => "blabla blabla", :author_id => author.id, :receiver_id => receiver.id,
                              :created_at => DateTime.now, :updated_at => Time.now)
    
    assert_equal(author.id, message.author_id)
    assert_equal(author, message.author)
    assert_equal(receiver.id, message.receiver_id)
    assert_equal(receiver, message.receiver)
    assert(!message.is_read, "Message shouldn't be read!")
    assert(!message.author_deleted, "Message shouldn't be deleted by author!")
    assert(!message.receiver_deleted, "Message shouldn't be deleted by receiver!")
    assert(message.created_at < Time.now, "Message isn't created in the past!")
    assert(message.updated_at < Time.now, "Message isn't updated in the past!")
    assert(message.created_at <= message.updated_at, "message.updated_at should be greater/equal than message.created_at!")
  end
  
end
