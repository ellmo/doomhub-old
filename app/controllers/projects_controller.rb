class ProjectsController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :user, :optional => true, :finder => :find_by_login!
  load_and_authorize_resource :user
  load_and_authorize_resource :project, :through => :user

#===============
#= CRUD ACTIONS
#=============

  def index
    build_breadcrumbs
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @projects }
    end
  end

  def show
    build_breadcrumbs
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @project }
    end
  end

  def new
    build_breadcrumbs
    add_breadcrumb 'New', new_project_path
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @project }
    end
  end

  def edit
    build_breadcrumbs
    add_breadcrumb 'Edit', edit_project_path(@project)
  end

  def create
    @project.creator = current_user
    @project.url_name = @project.name unless (params[:project][:url_name].present?)

    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, :notice => 'Project was successfully created.' }
        format.json { render :json => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    params[:project][:url_name] = @project.name unless (params[:project][:url_name].present?)

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to edit_project_path(@project), :notice => 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

#==========
#= METHODS
#========

  protected

  def build_breadcrumbs
    add_breadcrumb "Users", :users_path, :allowed => @user.superadmin? if @user
    add_breadcrumb @user.login, user_path(@user) if @user
    add_breadcrumb (@user ? "#{@user.login}'s projects" : 'Projects'), :collection_path
    add_breadcrumb @project.name, project_path(@project) if @project and !@project.new_record?
  end

end
