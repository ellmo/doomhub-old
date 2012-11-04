class UsersController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!
  before_filter :build_breadcrumbs, :if => 'request.format == :html'

#============
#= RESOURCES
#==========

  inherit_resources
  load_and_authorize_resource :user

#==========
#= METHODS
#========

protected

  def build_breadcrumbs
    add_breadcrumb "Users", :users_path, :allowed => current_user.superadmin?
    add_breadcrumb resource.login, user_path(resource) if action_name != 'index'
  end

end
