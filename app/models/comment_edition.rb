class CommentEdition < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :comment
  belongs_to :user

end
