class CreateProjectInvitations < ActiveRecord::Migration
  def self.up
    create_table :project_invitations do |t|
      t.integer :project_id, :null => false
      t.integer :user_id, :null => false
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :project_invitations
  end
end
