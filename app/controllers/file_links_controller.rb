class FileLinksController < ApplicationController

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
  load_and_authorize_resource :file_link, :through => :map

#===============
#= CRUD ACTIONS
#=============

  def new
    build_breadcrumbs
  end

  def create
    @file_link = @map.map_images.build(params[:file_link])
    @file_link.name = params[:file_link][:name].present? ? params[:file_link][:name] : @map.slug
    @file_link.auhtorable = current_user unless (params[:file_link][:authorable_id].present? and admin?)

    respond_to do |format|
      if @file_link.save
        format.html { redirect_to [@project, @map], :notice => 'File link was successfully added.' }
        format.json { render :json => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @file_link.destroy
        format.html { redirect_to [@project, @map], :notice => 'Image was successfully destroyed.' }
        format.json { render :json => @map, :location => @map }
      else
        format.html { redirect_to [@project, @map], :error => 'Image was NOT destroyed.' }
        format.json { render :status => :unprocessable_entity }
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
    case parent.class
    when Project
      add_breadcrumb "Resources", project_map_path(@project, @map, :anchor => 'resources')
    when Map
      add_breadcrumb "Maps", project_path(@project, :anchor => 'maps')
      add_breadcrumb @map.name, project_map_path(@project, @map)
      add_breadcrumb "File links", project_map_path(@project, @map, :anchor => 'links')
    end
  end
end
