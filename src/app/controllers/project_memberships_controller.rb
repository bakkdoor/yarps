class TeamMembershipsController < ApplicationController
  # GET /team_memberships
  # GET /team_memberships.xml
  def index
    @team_memberships = TeamMembership.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @team_memberships }
    end
  end

  # GET /team_memberships/1
  # GET /team_memberships/1.xml
  def show
    @team_membership = TeamMembership.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team_membership }
    end
  end

  # GET /team_memberships/new
  # GET /team_memberships/new.xml
  def new
    @team_membership = TeamMembership.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team_membership }
    end
  end

  # GET /team_memberships/1/edit
  def edit
    @team_membership = TeamMembership.find(params[:id])
  end

  # POST /team_memberships
  # POST /team_memberships.xml
  def create
    @team_membership = TeamMembership.new(params[:team_membership])

    respond_to do |format|
      if @team_membership.save
        flash[:notice] = 'TeamMembership was successfully created.'
        format.html { redirect_to(@team_membership) }
        format.xml  { render :xml => @team_membership, :status => :created, :location => @team_membership }
      else
        flash[:error] = "irgendwas lief falsch..."
        format.html { render :action => "new" }
        format.xml  { render :xml => @team_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /team_memberships/1
  # PUT /team_memberships/1.xml
  def update
    @team_membership = TeamMembership.find(params[:id])

    respond_to do |format|
      if @team_membership.update_attributes(params[:team_membership])
        flash[:notice] = 'TeamMembership was successfully updated.'
        format.html { redirect_to(@team_membership) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team_membership.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /team_memberships/1
  # DELETE /team_memberships/1.xml
  def destroy
    @team_membership = TeamMembership.find(params[:id])
    @team_membership.destroy

    respond_to do |format|
      format.html { redirect_to(team_memberships_url) }
      format.xml  { head :ok }
    end
  end
end
