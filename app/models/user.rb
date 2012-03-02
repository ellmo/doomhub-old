class User < ActiveRecord::Base
  
  ##########
  # DEVISE #
  ##########

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  #########
  # ASSOC #
  #########

  belongs_to :user_role

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


end
