class ProjectMembership < ActiveRecord::Base
    belongs_to :user
    belongs_to :project
    
    validates_presence_of :user_id
    validates_presence_of :project_id
    validates_presence_of :user_level
    
    def project
      Project.find(self.project_id)
    end
    
    def user
      User.find(self.user_id)
    end
end
