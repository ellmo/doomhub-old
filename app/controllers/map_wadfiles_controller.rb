class MapWadfilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]
  load_and_authorize_resource

  before_filter :find_parent_resource
  before_filter :find_resource, :except => [:index, :new, :create]

private

  def find_parent_resource
    @map = map.find_by_slug(params[:map_id])
  end

  def find_resource
    @wadfile = MapWadfile.find(params[:id])
  end

public

  def index
    @wadfiles = @map.wadfiles

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
    @wadfile = @map.wadfiles.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @wadfile }
    end
  end

  def edit
  end

  def create
    @wadfile = @map.wadfiles.build(params[:map_wadfile])
    @wadfile.author = current_user unless (params[:map_wadfile][:author_id].present? and admin?)

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
    @map.destroy

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
