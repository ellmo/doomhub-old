class NewsController < ApplicationController

#==========
#= FILTERS
#========

  before_filter :authenticate_user!, :except => [:show, :index]

#============
#= RESOURCES
#==========

  inherit_resources
  defaults :resource_class => News, :collection_name => 'news', :instance_name => 'news_entry'

#===============
#= CRUD ACTIONS
#=============

  def index
    build_breadcrumbs
    @news = collection
  end

  def show
    build_breadcrumbs
  end

  def new
    @news_entry = News.new
    build_breadcrumbs
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @news_entry }
    end
  end

  def create
    @news_entry = News.new(params[:news])
    @news_entry.user = current_user

    respond_to do |format|
      if @news_entry.save
        format.html { redirect_to news_index_path, :notice => 'News entry was successfully added' }
        format.json { render :json => @news_entry, :status => :created }
      else
        format.html { render :action => "new" }
        format.json { render :json => @news_entry.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    build_breadcrumbs
  end

#==========
#= METHODS
#========

  protected

  def build_breadcrumbs
    add_breadcrumb "News", :root_path
  end

end
