class AddDeletedFieldsToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :receiver_deleted, :boolean
    add_column :messages, :author_deleted, :boolean
  end

  def self.down
    remove_column :messages, :receiver_deleted
    remove_column :messages, :author_deleted
  end
end
