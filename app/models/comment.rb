class Comment < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

#=======
#= ATTR
#=====

  attr_accessible :commentable_id, :commentable_type, :content, :user_id

end
