class ProjectsController < ApplicationController
  
  auto_complete_for :project, :name
  auto_complete_for :tag, :name
  
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  before_filter :init_project_tags_session, :only => [:create, :update]
  
  # GET /projects
  # GET /projects.xml
  def index
    if logged_in?
      @projects = current_user.projects.sort_by(&:name)
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @projects }
      end
    end
  end
  
  def list
    @projects = Project.all_public
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    if ! Project.exists?(params[:id])
      redirect_to :action => :index
    else
      @project = Project.find(params[:id])
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @project }
      end
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
    @project.tag_list = session[:project_tags]
    
    session[:project_tags] = []
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
    
    session[:project_tags] = []
    
    # save names of project-tags in session
    @project.tags.each do |t|
      session[:project_tags] << t.name
    end
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    
    # add tags, only if there are any specified
    @project.tag_list = session[:project_tags]

    respond_to do |format|
      if @project.save
        @project_membership = ProjectMembership.new :user_id => current_user.id,
                                                    :project_id => @project.id,
                                                    :user_level => User.level_code(:project_admin)
        if @project_membership.save       
          session[:project_tags] = nil # reset                                   
          flash[:notice] = (l :project_successful_create_notice)
          format.html { redirect_to(@project) }
          format.xml  { render :xml => @project, :status => :created, :location => @project }
        else
          format.html { render :action => :new}
          format.xml { render :xml => @project.errors, :status => :unprocessable_entity }
        end
      else
        format.html { render :action => :new }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = Project.find(params[:id])
    
    # add new tags, only if any specified
    params[:new_tags].split(",").each do |new_tag|
      session[:project_tags] << new_tag
    end
    
    @project.tag_list = session[:project_tags]
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
        session[:project_tags] = nil # zurücksetzen
        flash[:notice] = (l :project_successful_update_notice)
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => :edit }
        format.xml  { render :xml => @Project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    if request.delete?
      @project = Project.find(params[:id])
      
      # also delete all project-memberships
      @project.project_memberships.each do |membership|
        membership.destroy
      end
      
      # and finally the project itself...
      @project.destroy
      
      respond_to do |format|
        format.html { redirect_to(projects_url) }
        format.xml  { head :ok }
      end
    else
      redirect_to(projects_url)
    end
  end
  
  def project_info
    @project = Project.find(params[:id])
    render :partial => "project_info", :object => @project
  end

  # personal projects...
  def my
    if logged_in?
      @project_memberships = current_user.project_memberships
    else
      redirect_to :action => :index
    end
  end
  
  def auto_complete_for_project_name
    @tags = Tag.find(:all, 
      :conditions => [ 'LOWER(name) LIKE ? ',
      '%' + params[:tag][:name].downcase + '%' ], 
      :order => 'name ASC')
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
  
  def auto_complete_for_tag_name
    @tags = Tag.find(:all, 
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + params[:tag][:name].downcase + '%' ], 
      :order => 'name ASC')
      
    # only return tags, that aren't used yet...
    @tags = @tags.select do |t|
      not session[:project_tags].include? t.name
    end
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
  end
  
  
  
  def search_tags
    if params[:search] != ""
      @tags = Tag.search(params[:search])
      
      if @tags.size > 0
        # loop through project-tags-session (if exists)
        # and mark all tags, which are already added to the project
        # => only show remaining tags as searchresult, which haven't been added to project yet
        # the used tags won't be shown in the view, by checking boolean value of :in_project in hash
        # via css: style="display:none"
        
        # a list of hashes, each having a tag and a boolean, if it's already used
        @tag_used_pairs = [] 
        if session[:project_tags]
          @tags = @tags.each do |tag|
            @tag_used_pairs << { :tag => tag, :in_project => session[:project_tags].include?(tag.name) }
          end
        end
            
        render :partial => "add_tag_list", :object => @tag_used_pairs
      else
        render :text => "<br>Keine Tags gefunden."
      end
    else
      render :text => ""
    end
  end
  
  def add_tag
    session[:project_tags] << params[:tag] unless session[:project_tags].include? params[:tag]
    
    render :partial => "tag_list_item", :collection => session[:project_tags]
  end
  
  def remove_tag
    session[:project_tags].delete params[:tag]
   
    render :partial => "tag_list_item", :collection => session[:project_tags]
  end
  
  # shows all (public) projects of a given tag
  def tag
    @projects = Project.find_tagged_with( params[:id], 
                                          :match_all => true,
                                          :conditions => ["public=?", true])
    @tagname = params[:id]
  end
  
  def search_projects
    if params[:search] != ""
      @projects = Project.search(params[:search])
      render :partial => "project_list", :object => @projects
    else
      render :text => ""
    end
  end
  
  private
  
  def init_project_tags_session
    session[:project_tags] ||= []
  end
  
end
