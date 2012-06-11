class UserRole < ActiveRecord::Base

#========
#= ASSOC
#======

  has_many :users

end
