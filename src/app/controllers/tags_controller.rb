class TagsController < ApplicationController
  
  # home screen, startpage
  def index
    redirect_to :controller => :projects, :action => :tags, :id => :all
  end
  
end
