class UsersController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!

#============
#= RESOURCES
#==========

  inherit_resources
  load_and_authorize_resource :user

end
