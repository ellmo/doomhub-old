class Author < ActiveRecord::Base

#========
#= ASSOC
#======

  has_many :maps, :as => :authorable
  has_many :map_wadfiles, as: :authorable
  has_many :map_images, as: :authorable

end
