require 'digest/sha1'
class User < ActiveRecord::Base
  
  has_many :team_memberships
  has_many :teams, :through => :team_memberships
  
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
  
  # searching for users
  def self.search(query)
    if query
       find(:all, :conditions => ["login LIKE ?", "%#{query}%"])
     else
       find(:all)
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
    when :projectmanager
      80
    when :user
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
      -1 # das hier ist ungültig!
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
    when 80
      "Projectmanager"
    when 10
      "User"
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