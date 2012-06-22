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

#===============
#= CRUD ACTIONS
#=============

  def index
    build_breadcrumbs
  end

  def show
    build_breadcrumbs
  end

#==========
#= METHODS
#========

protected

  def build_breadcrumbs
    add_breadcrumb "Users", :users_path, :allowed => @user.superadmin?
    add_breadcrumb @user.login, user_path(@user)
  end

end
