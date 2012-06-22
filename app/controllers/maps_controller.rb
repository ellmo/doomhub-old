class MapsController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :project, :optional => true, :finder => :find_by_slug!
  load_and_authorize_resource :project
  load_and_authorize_resource :map

#===============
#= CRUD ACTIONS
#=============

public

  def index
  end

  def show
    build_breadcrumbs
  end

  def new
    build_breadcrumbs
    add_breadcrumb "New", new_project_map_path(@project)
  end

  def edit
    build_breadcrumbs
    add_breadcrumb "Edit", edit_project_map_path(@project)
  end

  def create
    @map = @project.maps.build(params[:map])
    @map.author = current_user unless (params[:map][:author_id].present? and admin?)
    @map.lump = @project.game.default_lumpname unless (params[:map][:lump].present?)

    respond_to do |format|
      if @map.save
        format.html { redirect_to edit_project_map_path(@project, @map), :notice => 'Map was successfully created.' }
        format.json { render :json => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.html { redirect_to edit_project_map_path(@project, @map), :notice => 'Map was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @map.destroy

    respond_to do |format|
      format.html { redirect_to project_maps_url(@project) }
      format.json { head :ok }
    end
  end

#==========
#= METHODS
#========

  protected

  def build_breadcrumbs
    add_breadcrumb "Projects", :projects_path
    add_breadcrumb @project.name, project_path(@project)
    add_breadcrumb "Maps", project_path(@project, :anchor => 'maps')
    add_breadcrumb @map.name, project_map_path(@project, @map) if @map and !@map.new_record?
  end

end
