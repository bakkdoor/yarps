class CreateProjectMemberships < ActiveRecord::Migration
  def self.up
    create_table :project_memberships do |t|
      t.integer :user_id, :null => false
      t.integer :project_id, :null => false
      t.integer :user_level, :default => User.level_code(:waitin_for_auth)

      t.timestamps
    end
  end

  def self.down
    drop_table :project_memberships
  end
end
