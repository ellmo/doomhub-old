class Project < ActiveRecord::Base

#==============
#= FRIENDLY_ID
#============

  extend FriendlyId
  friendly_id :url_name, :use => [:slugged, :history]

#========
#= ASSOC
#======

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  belongs_to :game
  belongs_to :source_port
  belongs_to :item_access

  has_many :item_invites, :as => :invitable
  has_many :maps, :dependent => :delete_all
  has_many :users, :through => :item_invites

#==============
#= VALIDATIONS
#============

  validates :name, :presence => true, :uniqueness => true
  validates :url_name, :presence => true, :uniqueness => true

end
