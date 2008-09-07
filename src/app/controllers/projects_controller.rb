class ProjectsController < ApplicationController
  
  auto_complete_for :project, :name
  auto_complete_for :tag, :name
  
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy]
  
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
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = Project.new(params[:project])
    
    respond_to do |format|
      if @project.save
        @project_membership = ProjectMembership.new :user_id => current_user.id,
                                                    :project_id => @project.id,
                                                    :user_level => User.level_code(:project_admin)
        if @project_membership.save       
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
    
    respond_to do |format|
      if @project.update_attributes(params[:project])
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
    input_tags = params[:project][:tag_list].split(" ")
    tag_name = input_tags.last
    used_tags = input_tags - [input_tags.last]
    
    @tags = Tag.find(:all, 
      :conditions => [ 'LOWER(name) LIKE ?',
      '%' + tag_name.downcase + '%' ], 
      :order => 'name ASC')
      
    # only return tags, that aren't used yet...
    @tags = @tags.select do |t|
      not used_tags.include? t.name
    end
    render :inline => "<%= auto_complete_result(@tags, 'name') %>"
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
  
end
