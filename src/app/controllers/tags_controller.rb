class TagsController < ApplicationController
  
  # home screen, startpage
  def index
    redirect_to :action => :projects
  end
  
  def projects
    @tags = Project.tag_counts
  end
  
end
