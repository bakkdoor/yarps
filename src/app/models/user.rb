require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  
  has_many :project_memberships
  has_many :projects, :through => :project_memberships
  has_many :project_invitations
  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  
  
  
  
  # returns all projects which have changed since a given date_time
  def changed_projects_since(date_time)
    @projects = self.projects.select{|p| p.updated_at >= date_time}
  end
  
  def is_a_project_admin?
    self.project_memberships.each do |m|
      if m.user_level == User.level_code(:project_admin)
        return true
      end
    end
      
    false
  end
  
  # indicates, if a user can join a project
  def can_join?(project)
       (project.public && !project.invite_only) || (self.has_invitation_for?(project))
  end
  
  # joins a project, if possible
  def join(project)
    if self.can_join?(project)
      membership = ProjectMembership.new(:project_id => project.id, :user_id => self.id, :user_level => User.level_code(:new_member))
      membership.save
      
      # search for project_invitation and delete it, if available
      # if not => error, since something obviously went wrong!
      if self.has_invitation_for?(project)
        invitation = ProjectInvitation.find_by_user_id_and_project_id(self.id, project.id)
        
        if invitation
          invitation.destroy
        else
          raise ActiveRecord::RecordNotFound, "Invitation doesn't seem to exist. Something is wrong here!"
        end
        
      end
    end
  end
  
  def can_invite_users_to_project?(project)
    membership = ProjectMembership.find_by_user_id_and_project_id(self.id, project.id)
    if membership
      membership.user_level >= 80
    else
      false
    end
  end
  
  # invite a user to a project
  # if no message is given, a standard message will be sent.
  def invite_user_to_project(user, project, message = nil)
    if can_invite_users_to_project?(project)
      message ||= ProjectInvitation.default_message(project.name, self.login)
      if user && project
        ProjectInvitation.create(:user_id => user.id, :project_id => project.id, :message => message)
      else
        logger.error "error while trying to invite user to project: user_id => #{user.id}, project_id => #{project.id}, message => #{message}"
      end
    end
  end
  
  # indicates, if the user has an invitation for a given project
  def has_invitation_for?(project)
    ProjectInvitation.find(:first, :conditions => ["user_id = ? AND project_id = ?", self.id, project.id])
  end
  
  # returns all received messages
  def received_messages
    Message.find(:all, :order => "created_at DESC", :conditions => ["receiver_id = ? AND receiver_deleted = ?", self.id, false])
  end
  
  # returns all sent messages
  def sent_messages
    Message.find(:all, :order => "created_at DESC", :conditions => ["author_id = ? AND author_deleted = ?", self.id, false])
  end
  
  # returns all unread (new) messages
  def new_messages
    Message.find(:all, :conditions => ["receiver_id = ? AND receiver_deleted = ? AND is_read = ?", self.id, false, false])
  end
  
  def amount_new_messages
    self.new_messages.size
  end
  
  # indicates, if there are any new messages
  def has_new_messages?
    self.new_messages.size > 0
  end
  
  def can_delete_message?(message)
    (message.author_id == self.id) || (message.receiver_id == self.id)
  end
  
  def delete_message(message)
    if message.author_id == self.id
      message.author_deleted = true
      message.save
    elsif message.receiver_id == self.id
      message.receiver_deleted = true
      message.save
    end
  end
  
  def can_read_message?(message)
    (message.author_id == self.id) || (message.receiver_id == self.id)
  end
  
  def read_message(message)
    if can_read_message?(message) && message.receiver_id == self.id
      message.is_read = true
      message.save
    end
  end
  
  # searching for users
  def self.search(query)
    if query
       find(:all, :order => "login ASC", :conditions => ["login LIKE ?", "%#{query}%"])
     else
       find(:all)
     end
  end
  
  # returns all public projects of a user
  def public_projects
    self.projects.select do |p|
      p.public
    end
  end
  
  # returns a user_level_code based on a given level_name-symbol
  # for example: :admin => 100
  def self.level_code(level_name)
    case level_name
    when :admin
      100
    when :moderator
      90
    when :project_admin
      85
    when :projectmanager
      80
    when :project_member
      10
    when :bugreporter
      8
    when :readonly
      5
    when :new_member
      1
    when :waitin_for_auth
      0
    else
      #-1 # this is not valid, normally this shouldn't happen!
      raise InvalidUserLevelError.new("Userlevel unknown: '#{level_name}'")
    end
  end

  # returns a string based on a given user_level_code
  # for example: 100 -> "admin"
  def self.level_name(level_code)
    case level_code
    when 100
      "Admin"
    when 90
      "Moderator"
    when 85
      "Project-Admin"
    when 80
      "Project-Manager"
    when 10
      "Project member"
    when 8
      "Bugreporter"
    when 5
      "Readonly"
    when 1
      "New member"
    when 0
      "Waiting for authorization"
    when -1
      "No rights at all!" # corresponds to 0
    else
      "Unknown" # normally this shouldn't happen!
    end
  end
  
  
  


  protected
    
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end


end
