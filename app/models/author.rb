class Author < ActiveRecord::Base

#========
#= ASSOC
#======

  has_many :maps, as: :authorable
  has_many :uploads, as: :authorable
  has_many :map_images, as: :authorable
  has_many :file_links, as: :authorable

end
