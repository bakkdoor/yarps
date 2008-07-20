class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string  :name,          :null => false
      t.text    :description
      t.string  :website
      t.boolean :public,        :default => 1
      t.boolean :invite_only,   :default => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :projects
  end
end
