class CommentsController < ApplicationController

  before_filter :load_by_pagination, only: [:index]

#===========
#= RESPONSE
#=========

  respond_to :html, :json, :js

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :project, :finder => :find_by_slug!#, :polymorphic => true
  load_and_authorize_resource :project
  load_and_authorize_resource :comment, :through => :project

#===============
#= CRUD ACTIONS
#=============

  def index
    redirect_to project_path(@project, :anchor => 'comments/p2', :page => params[:page]) if request.format == :html
  end

  def create
    @comment.user = current_user
    @comment.save ? load_by_pagination : render(json: {success: false})
  end

  def update
    if @comment.update_attributes params[:comment].merge({:bumped => false, :user => current_user})
      @comments = parent.comments
    else
      render :json => @comment.errors, :status => :unprocessable_entity
    end
  end

  def destroy
    unless @comment.destroy
      render :json => { :success => false }, :status => 422
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

  def collection
    @comments ||= end_of_association_chain.page params[:page]
  end

  def load_by_pagination
    @comments = end_of_association_chain.order("created_at").page params[:page]
  end

end
