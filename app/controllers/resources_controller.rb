class ResourcesController < ApplicationController
  inherit_resources
  belongs_to :project, :optional => true, :finder => :find_by_slug!
  belongs_to :map, :optional => true, :finder => :find_by_slug!
  load_and_authorize_resource :project
  load_and_authorize_resource :map, :through => :project

  before_filter :authenticate_user!, only: [:new]

  def index; end

  def new
    @file_link = parent.file_links.build
    @map_wadfile = parent.map_wadfiles.build
  end

end
