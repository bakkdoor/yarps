class Team < ActiveRecord::Base
    
    has_many :team_memberships
    has_many :users, :through => :team_memberships
    
    validates_presence_of :name, :on => :create, :message => (l :please_enter_a_name)
    
    # searching for teams
    def self.search(query)
      if query
         find(:all, :conditions => ["name LIKE ? AND public=?", "%#{query}%", true])
       else
         find(:all)
       end
    end
    
    def self.search_first_letters(start_letters)
        if start_letters
            find(:all, :conditions => ["name LIKE ? AND public=?", "#{start_letters}%", true])
        else
            []
        end
    end
end
