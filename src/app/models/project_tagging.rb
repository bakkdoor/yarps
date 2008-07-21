class ProjectTagging < ActiveRecord::Base
    belongs_to :tag
    belongs_to :project
    
    validates_presence_of :tag_id
    validates_presence_of :project_id
    
    def project
      Project.find(self.project_id)
    end
    
    def tag
      Tag.find(self.tag_id)
    end
end
