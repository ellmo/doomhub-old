class News < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :user

#==============
#= VALIDATIONS
#============

  validates :user, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true

end
