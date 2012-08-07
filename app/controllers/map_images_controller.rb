class MapImagesController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :project, :optional => true, :finder => :find_by_slug!
  belongs_to :map, :optional => true, :finder => :find_by_slug!
  load_and_authorize_resource :project
  load_and_authorize_resource :map, :through => :project
  load_and_authorize_resource :map_image, :through => :map

#===============
#= CRUD ACTIONS
#=============

  def new
    build_breadcrumbs
  end

  def create
    params[:map_image][:name] ||= @map.slug
    @map_image = @map.map_images.build(params[:map_image])
    @map_image.user = current_user unless (params[:map_image][:user_id].present? and admin?)

    respond_to do |format|
      if @map_image.save
        format.html { redirect_to [@project, @map], :notice => 'Wad file was successfully added.' }
        format.json { render :json => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
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
    add_breadcrumb "Maps", project_path(@project, :anchor => 'maps')
    add_breadcrumb @map.name, project_map_path(@project, @map)
    add_breadcrumb "Map Images", project_map_path(@project, @map, :anchor => 'images')
  end

end
