class MessagesController < ApplicationController
  
  before_filter :login_required
  
  auto_complete_for :receiver, :login
  
  # GET /messages
  # GET /messages.xml
  def index
    #@messages = Message.find(:all)
    @messages = current_user.received_messages
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message }
    end
    
    if @message.receiver == current_user
      @message.is_read = true
      @message.save
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])
    @message.author_id = current_user.id
    @message.receiver_id = User.find_by_login(params[:receiver][:login], :limit => 1).id
    
    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully sent.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    
    if current_user.can_delete_message?(@message)
      current_user.delete_message(@message)
    else
      flash[:error] = (l :message_cant_be_deleted)
    end
    
    if @message.all_deleted?
      @message.destroy
    end

    respond_to do |format|
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
  
  # auf vorhandene nachricht antworten
  def reply
    @message = Message.new
    @old_message = Message.find(params[:id])
    
    respond_to do |format|
      format.html # reply.rhtml
    end
  end
  
  # nachrichten inbox
  def inbox
    @messages = current_user.received_messages
  end
  
  # gesendete nachrichten
  def sent
    @messages = current_user.sent_messages
  end
  
  def auto_complete_for_receiver_login
    @receivers = User.find(:all, 
      :conditions => [ 'LOWER(login) LIKE ? AND login <> ?',
      '%' + params[:receiver][:login].downcase + '%', current_user.login ], 
      :order => 'login ASC')
    render :inline => "<%= auto_complete_result(@receivers, 'login') %>"
  end
  
  
end
