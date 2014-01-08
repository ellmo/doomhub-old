class Map < ActiveRecord::Base

  extend FriendlyId

  acts_as_paranoid

#========
#= ASSOC
#======

  belongs_to :authorable, polymorphic: true
  belongs_to :project

  has_many :comments, as: :commentable
  has_many :map_images
  has_many :map_wadfiles
  has_many :file_links, as: :file_linkable

#==============
#= FRIENDLY_ID
#============

  friendly_id :name, :use => [:slugged, :history]

#==============
#= VALIDATIONS
#============

  validates :name, :presence => true
  validate :has_5_wadfiles_max
  validate :user_can_map

#============
#= CALLBACKS
#==========

  before_save :get_default_lumpname, if: ->(m) {m.lump.nil?}

  def get_default_lumpname
    self.lump = project.game.default_lumpname
  end

#==========
#= METHODS
#========

private

  def has_5_wadfiles_max
    errors.add(:base, "cannot have more than 5 wadfiles") if map_wadfiles.size > 5
  end

  def user_can_map
    errors.add(:base, "user cannot add maps for this project") unless authorable.is_a?(User) and project.mappable_by?(authorable)
  end

end
