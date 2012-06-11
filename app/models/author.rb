class Author < ActiveRecord::Base

#========
#= ASSOC
#======

  has_many :maps, :as => :author

end
