class AddReadToMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :is_read, :boolean, :default => false
  end

  def self.down
    remove_column :messages, :is_read
  end
end
