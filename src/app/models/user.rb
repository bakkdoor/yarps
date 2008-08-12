require 'digest/sha1'
class User < ActiveRecord::Base
  
  has_many :project_memberships
  has_many :projects, :through => :project_memberships
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  def is_a_project_admin?
    self.project_memberships.each do |m|
      if m.user_level == User.level_code(:project_admin)
        return true
      end
    end
      
    false
  end
  
  # gibt an, ob user projekt beitreten kann
  def can_join?(project)
    (project.public && !project.invite_only) || (project.public && project.invite_only && self.has_invitation_for?(project))
  end
  
  # tritt einem projekt bei, falls möglich
  def join(project)
    if self.can_join?(project)
      membership = ProjectMembership.new(:project_id => project.id, :user_id => self.id, :user_level => User.level_code(:new_member))
      membership.save
    end
  end
  
  # gibt an, ob eine einladung vorliegt, einem projekt beizutreten
  def has_invitation_for?(project)
    ProjectInvitation.find(:first, :conditions => ["user_id = ? AND project_id = ?", self.id, project.id])
  end
  
  # gibt alle empfangenen nachrichten zurück
  def received_messages
    Message.find(:all, :order => "created_at DESC", :conditions => ["receiver_id = ? AND receiver_deleted = ?", self.id, false])
  end
  
  # gibt alle verschickten nachrichten zurück
  def sent_messages
    Message.find(:all, :order => "created_at DESC", :conditions => ["author_id = ? AND author_deleted = ?", self.id, false])
  end
  
  def new_messages
    Message.find(:all, :conditions => ["receiver_id = ? AND receiver_deleted = ? AND is_read = ?", self.id, false, false])
  end
  
  def amount_new_messages
    self.new_messages.size
  end
  
  def has_new_messages?
    self.new_messages.size > 0
  end
  
  # searching for users
  def self.search(query)
    if query
       find(:all, :order => "login ASC", :conditions => ["login LIKE ?", "%#{query}%"])
     else
       find(:all)
     end
  end
  
  # alle öffentlichen projekte
  def public_projects
    self.projects.select do |p|
      p.public
    end
  end
  
  # gibt den user_level_code in abhängigkeit von einem level_namen-symbol zurück
  # bsp: :admin -> 100
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
      #-1 # das hier ist ungültig, sollte eigentlich nicht auftreten!
      raise InvalidUserLevelError.new("Userlevel unknown: '#{level_name}'")
    end
  end

  # gibt einen string passend zum user_level_code zurück
  # bsp: 100 -> "admin"
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
      "No rights at all!" # entspricht 0
    else
      "Unknown" # das hier sollte eigentlich nicht auftreten!
    end
  end
  
  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
    
    def password_required?
      crypted_password.blank? || !password.blank?
    end
end
