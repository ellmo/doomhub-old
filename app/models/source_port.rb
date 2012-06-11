class SourcePort < ActiveRecord::Base

#========
#= ASSOC
#======

  has_many :projects
end
