require 'digest/sha1'
class User < ActiveRecord::Base
  attr_accessor :password
  attr_writer   :uploaded_portrait

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false

  before_save :encrypt_password
  before_create :make_activation_code
  before_save :save_uploaded_portrait
  before_save :cleanup_phone_number

  belongs_to :portrait, :foreign_key => 'portrait_id', :class_name => 'Photo'

  has_many    :positions, :dependent => :destroy
  has_many    :teams, :through => :positions
  has_many    :photos
  has_many    :marks
  has_many    :references, :through => :marks, :source => :photo

  # hiring
  has_many :comments

  def to_param
    login
  end

  def formatted_extension
    "#{extension[0..2]}-#{extension[3..5]}-#{extension[6..9]}" unless extension.blank?
  end

  def formatted_cell
    "#{cell[0..2]}-#{cell[3..5]}-#{cell[6..9]}" unless cell.blank?
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    # hide records with a nil activated_at
    u = find :first, :conditions => ['login = ?', login]
    u && u.authenticated?(password) ? u : nil
  end

  def admin?
    self.admin == 1
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

  # Activates the user in the database.
  def activate
    @activated = true
    update_attributes(:activated_at => Time.now.utc, :activation_code => nil)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  alias_method :original_to_xml, :to_xml
  def to_xml(options = {})
    original_to_xml({:except => [:salt, :crypted_password]}.merge(options))
  end

  def forgot_password
    @forgotten_password = true
    self.make_password_reset_code
  end

  def reset_password
    # First update the password_reset_code before setting the
    # reset_password flag to avoid duplicate email notifications.
    update_attributes(:password_reset_code => nil)
    @reset_password = true
  end

  def recently_reset_password?
    @reset_password
  end

  def recently_forgot_password?
    @forgotten_password
  end

  def self.search(query)
    unless query.to_s.strip.empty?
      tokens = query.split.collect {|c| "%#{c.to_s.downcase}%"}
      find_by_sql(["select u.* from users u where #{ (["(lower(u.login) like ? or lower(u.login) like ?)"] * tokens.size).join(" and ") } order by u.created_at desc", *(tokens * 2).sort])
    else
      []
    end
  end

  protected

  def make_password_reset_code
    self.password_reset_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  protected
    # before filter
    def encrypt_password
      self.login = self.login.gsub(".", "") # FIXME
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    # If you're going to use activation, uncomment this too
    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

    def save_uploaded_portrait
      return if @uploaded_portrait.nil? || @uploaded_portrait.size == 0

      self.portrait = Photo.new(:content => @uploaded_portrait.read,
                                :user_id => self.id,
                                :mimetype => @uploaded_portrait.content_type.to_s.split("/")[0],
                                :name => @uploaded_portrait.original_filename)

      self.portrait.save!
      @uploaded_portrait = nil
      self.portrait_id = self.portrait.id
    end

    def cleanup_phone_number
      self.extension.gsub!(/[^0-9]/, "") if self.extension
      self.cell.gsub!(/[^0-9]/, "") if self.cell
      self.extension = "212219#{self.extension}" if self.extension and self.extension.size == 4
    end
end
