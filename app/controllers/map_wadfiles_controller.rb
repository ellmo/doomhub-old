class MapWadfilesController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index, :download]

#============
#= RESOURCES
#==========

  inherit_resources
  belongs_to :project, :optional => true, :finder => :find_by_slug!
  belongs_to :map, :optional => true, :finder => :find_by_slug!
  load_and_authorize_resource :project
  load_and_authorize_resource :map, :through => :project
  load_and_authorize_resource :map_wadfile, :through => :map

#===============
#= CRUD ACTIONS
#=============

  def new
    build_breadcrumbs
  end

  def create
    params[:map_wadfile][:name] ||= @map.slug
    @map_wadfile = @map.map_wadfiles.build(params[:map_wadfile])
    @map_wadfile.author = current_user unless (params[:map_wadfile][:author_id].present? and admin?)

    respond_to do |format|
      if @map_wadfile.save
        format.html { redirect_to [@project, @map], :notice => 'Wad file was successfully added.' }
        format.json { render :json => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @map_wadfile.destroy
        format.html { redirect_to [@project, @map], :notice => 'Wadfile was successfully destroyed.' }
        format.json { render :json => @map, :location => @map }
      else
        format.html { redirect_to [@project, @map], :error => 'Wadfile was NOT destroyed.' }
        format.json { render :status => :unprocessable_entity }
      end
    end
  end

#================
#= OTHER ACTIONS
#==============

  def download
    unless Rails.env.development?
      redirect_to @map_wadfile.wadfile.expiring_url(10)
    else
      redirect_to @map_wadfile.wadfile.url
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
    add_breadcrumb "Map Wadfiles", project_map_path(@project, @map, :anchor => 'wadfiles')
  end

end
