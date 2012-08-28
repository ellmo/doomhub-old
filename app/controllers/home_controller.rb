class HomeController < ApplicationController
  def index
    @news = News.order('created_at DESC')
  end
end
