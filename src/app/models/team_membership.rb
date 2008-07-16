class TeamMembership < ActiveRecord::Base
    belongs_to :user
    belongs_to :team
    
    validates_presence_of :user_id
    validates_presence_of :team_id
    validates_presence_of :user_level
end
