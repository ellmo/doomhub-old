class CommentsController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :project, :optional => true, :finder => :find_by_slug!, :polymorphic => true
  load_and_authorize_resource :project
  load_and_authorize_resource :comment, :through => :project

#===============
#= CRUD ACTIONS
#=============

  def show
    build_breadcrumbs
  end

  def new
    build_breadcrumbs
    add_breadcrumb "New", new_project_comment_path(@project)
  end

  def edit
    build_breadcrumbs
    add_breadcrumb "Edit", edit_project_comment_path(@project)
  end

  def create
    @comment.author = current_user

    respond_to do |format|
      if @comment.save
        format.html { redirect_to [@project, @comment], :notice => 'Map was successfully created.' }
        format.json { render :json => @comment, :status => :created, :location => @comment }
      else
        format.html { render :action => "new" }
        format.json { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

#==========
#= METHODS
#========

  protected

  def build_breadcrumbs
    add_breadcrumb "Projects", :projects_path
    add_breadcrumb @project.name, project_path(@project)
    add_breadcrumb "Comments", project_path(@project, :anchor => 'maps')
    add_breadcrumb @comment.id.to_s, project_comment_path(@project, @comment) if @comment and !@comment.new_record?
  end

end
