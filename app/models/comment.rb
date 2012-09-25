class Comment < ActiveRecord::Base

  include Rails.application.routes.url_helpers

#========
#= ASSOC
#======

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

#=======
#= ATTR
#=====

  attr_accessible :commentable_id, :commentable_type, :content, :user_id

#=========
#= SCOPES
#=======

  default_scope order('created_at DESC')

#==========
#= METHODS
#========

  def path
    polymorphic_path([commentable, self])
  end

end
