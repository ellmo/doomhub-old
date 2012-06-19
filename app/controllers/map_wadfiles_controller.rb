class MapWadfilesController < ApplicationController
  respond_to :html, :js

  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource

  before_filter :find_parent_resources
  before_filter :find_resource, :except => [:index, :new, :create]

private

  def find_parent_resources
    @map = Map.find_by_slug(params[:map_id])
    @project = @map.project
  end

  def find_resource
    @map_wadfile = MapWadfile.find(params[:id])
  end

public

  def index
    @map_wadfile = @map.wadfiles

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @wadfile }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @wadfile }
    end
  end

  def new
    @map_wadfile = @map.wadfiles.build
  end

  def edit
  end

  def create
    params[:map_wadfile][:name] = @map.slug
    @map_wadfile = @map.wadfiles.build(params[:map_wadfile])
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

  def update
    respond_to do |format|
      if @map.update_attributes(params[:map])
        format.html { redirect_to project_map_path(@project, @map), :notice => 'Project was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @map.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @map_wadfile.destroy

    respond_to do |format|
      format.html { redirect_to project_maps_url(@project) }
      format.json { head :ok }
    end
  end

  def download
    if @map_wadfile.downloadable?(current_user)
      redirect_to @map_wadfile.wadfile.expiring_url(10)
    else
      render :text => "SHIT"
    end
  end

end
