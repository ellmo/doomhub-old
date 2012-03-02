class MapsController < ApplicationController

  before_filter :find_parent_resource
  before_filter :find_resource, :only => [:show, :edit, :update, :destroy, :download]

private

  def find_parent_resource
    @project = Project.find_by_slug(params[:project_id])
  end

  def find_resource
    @map = Map.find(params[:id])
  end

public

  def index
    @maps = @project.maps

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @map }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @map }
    end
  end

  def new
    @map = Map.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @map }
    end
  end

  def edit
  end

  def create
    @map = @project.maps.build(params[:map])
    @map.author = current_user unless (params[:map][:author_id] and admin?)
    respond_to do |format|
      if @map.save
        format.html { redirect_to [@project, @map], :notice => 'Project was successfully created.' }
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

    respond_to do |format|
      format.html { redirect_to project_maps_url(@project) }
      format.json { head :ok }
    end
  end

  def download
    if @map.downloadable?(current_user)
      redirect_to @map.wadfile.expiring_url(10)
    else
      render :text => "SHIT"
    end
  end

end
