class ProjectTagging < ActiveRecord::Base
    belongs_to :tag
    belongs_to :project
    
    validates_presence_of :tag_id
    validates_presence_of :project_id
end
