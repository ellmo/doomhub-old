class Map < ActiveRecord::Base

  extend FriendlyId

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :author, :polymorphic => true
  belongs_to :project

  has_many :comments, :as => :commentable
  has_many :map_images
  has_many :map_wadfiles

#==============
#= FRIENDLY_ID
#============

  friendly_id :name, :use => [:slugged, :history]

#==============
#= VALIDATIONS
#============

  validates :name, :presence => true
  validate :has_5_wadfiles_max

#============
#= CALLBACKS
#==========

  before_save :get_random_lumpname, if: ->(m) {m.lump.nil?}

  def get_random_lumpname
    self.lump = project.game.default_lumpname
  end

#==========
#= METHODS
#========

  def has_5_wadfiles_max
    errors.add_to_base("cannot have more than 5 wadfiles") if map_wadfiles.size > 5
  end

end
