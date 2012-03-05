class User < ActiveRecord::Base
  
  ##########
  # DEVISE #
  ##########

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def self.find_for_database_authentication(conditions={})
    self.find_by_login conditions[:login] or
    self.find_by_email conditions[:login]
  end

  #########
  # ASSOC #
  #########

  belongs_to :role, :class_name => "UserRole", :foreign_key => :user_role_id
  has_many :maps, :as => :author
  has_many :projects

  ########
  # ATTR #
  ########

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :login

  ##############
  # VALIDATION #
  ##############

  validates :login, :uniqueness => true
  validates :email, :uniqueness => true

  ###########
  # METHODS #
  ###########

  def superadmin?
    registered? and self.user_role_id == 1
  end

  def admin?
    registered? and self.user_role_id == 2
  end

  def regular?
    registered? and self.user_role_id == 3
  end

  def registered?
    self.id and self.role
  end

  def guest?
    self.id.nil?
  end

end
