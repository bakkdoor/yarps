class TeamMembership < ActiveRecord::Base
    belongs_to :user
    belongs_to :team
    
    validates_presence_of :user_id
    validates_presence_of :team_id
    validates_presence_of :user_level
    
    def team
      Team.find(self.team_id)
    end
    
    def user
      User.find(self.user_id)
    end
end
