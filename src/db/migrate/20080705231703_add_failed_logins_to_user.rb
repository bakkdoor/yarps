class AddFailedLoginsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :failed_logins, :integer
  end

  def self.down
    remove_column :users, :failed_logins
  end
end
