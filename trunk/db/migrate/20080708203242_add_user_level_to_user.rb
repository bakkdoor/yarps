class AddUserLevelToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :user_level, :integer, :default => User.level_code(:new_member) #new_member
  end

  def self.down
    remove_column :users, :user_level
  end
end
