class Project < ActiveRecord::Base

    acts_as_taggable
    
    has_many :project_memberships
    has_many :users, :through => :project_memberships
    has_many :project_invitations
    
    validates_presence_of :name, :on => :create, :message => (l :please_enter_a_name)
    
    # searching for projects
    def self.search(query)
      if query
         find(:all, :order => "name ASC", :conditions => ["name LIKE ? AND public=?", "%#{query}%", true])
       else
         find(:all)
       end
    end
    
    def self.all_public
      find_all_by_public(true, :order => "name ASC")
    end
    
    def self.search_first_letters(start_letters)
        if start_letters
            find(:all, :conditions => ["name LIKE ? AND public=?", "#{start_letters}%", true])
        else
            []
        end
    end
    
    def viewable_by?(user)
      ProjectMembership.find_by_user_id_and_project_id(user.id, self.id)
    end
end
