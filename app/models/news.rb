class News < ActiveRecord::Base

  acts_as_paranoid

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

#=========
#= SCOPES
#=======

  default_scope order('created_at DESC')

end
