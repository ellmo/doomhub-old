class ItemInvite < ActiveRecord::Base

#========
#= ASSOC
#======

  belongs_to :user
  belongs_to :invitable, :polymorphic => true

end
