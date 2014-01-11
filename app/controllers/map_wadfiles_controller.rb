class UploadsController < ApplicationController

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
  load_and_authorize_resource :uploads, :through => :map

#===============
#= CRUD ACTIONS
#=============

  def new
    build_breadcrumbs
  end

  def create
    params[:upload][:name] ||= @map.slug
    @upload = @map.uploads.build(params[:upload])
    @upload.authorable = current_user unless (params[:upload][:authorable_id].present? and admin?)

    respond_to do |format|
      if @upload.save
        format.html { redirect_to [@project, @map], :notice => 'Upload was successfully added.' }
        format.json { render :json => @map, :status => :created, :location => @map }
      else
        format.html { render :action => "new" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @upload.destroy
        format.html { redirect_to [@project, @map], :notice => 'Upload was successfully destroyed.' }
        format.json { render :json => @map, :location => @map }
      else
        format.html { redirect_to [@project, @map], :error => 'Upload was NOT destroyed.' }
        format.json { render :status => :unprocessable_entity }
      end
    end
  end

#================
#= OTHER ACTIONS
#==============

  def download
    if Rails.env.production?
      redirect_to @upload.archive.expiring_url(10)
    else
      redirect_to @upload.archive.url
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
    add_breadcrumb "Map Uploads", project_map_path(@project, @map, :anchor => 'uploads')
  end

end
