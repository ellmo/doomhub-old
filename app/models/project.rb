class Project < ActiveRecord::Base

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :creator, :class_name => "User", :foreign_key => "user_id"
  belongs_to :game
  belongs_to :item_access
  belongs_to :source_port

  has_many :comments, :as => :commentable
  has_many :item_invites, :as => :invitable
  has_many :map_images, :through => :maps
  has_many :maps, :dependent => :delete_all
  has_many :users, :through => :item_invites

#==============
#= FRIENDLY_ID
#============

  extend FriendlyId
  friendly_id :url_name, :use => [:slugged, :history]

#==============
#= VALIDATIONS
#============

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :url_name, :uniqueness => {:case_sensitive => false}

#============
#= CALLBACKS
#==========

  before_save :generate_default_url_name

  def generate_default_url_name
    unless self.url_name.present?
      self.url_name = name
      self.send :set_slug
    end
  end

#=========
#= SCOPES
#=======

  scope :public_view, where{public_view == true}
  scope :private_view, where{public_view == false}
  scope :public_join, where{public_join == true}
  scope :private_join, where{public_join == false}

  scope :readable_by, lambda { |user|
    return all if user.admin?
    if user.new_record?
      public_view
    else
      includes(:item_invites).where{
        (user_id == user.id) |
        (public_view == true) |
        (item_invites.user_id == user.id)
      }
    end
  }

  scope :mappable_by, lambda { |user|
    return all if user.admin?
    if user.new_record?
      public_join
    else
      includes(:item_invites).where{
        (user_id == user.id) |
        (public_join == true) |
        (item_invites.user_id == user.id)
      }
    end
  }

#==========
#= METHODS
#========

  def readable_by?(user)
    user == creator or
    public_view or
    users.include? user
  end

  def mappable_by?(user)
    user == creator or
    public_join or
    users.include? user
  end

end
