class Map < ActiveRecord::Base
  extend FriendlyId

#========
#= ASSOC
#======

  belongs_to :author, :polymorphic => true
<<<<<<< .merge_file_9umQfT
  has_many :map_wadfiles#, :class_name => "MapWadfile"

=======
  belongs_to :project

  has_many :comments, :as => :commentable
  has_many :map_images
  has_many :map_wadfiles

>>>>>>> .merge_file_Dl1jiQ
#==============
#= FRIENDLY_ID
#============

  friendly_id :name, :use => [:slugged, :history]

#==============
#= VALIDATIONS
#============

  validates :name, :presence => true
  validate :has_5_wadfiles_max

#==========
#= METHODS
#========

  def has_5_wadfiles_max
    errors.add_to_base("cannot have more than 5 wadfiles") if map_wadfiles.size > 5
  end

end
