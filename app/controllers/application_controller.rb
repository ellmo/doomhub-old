class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :root_breadcrumb

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root.to_s}/public/403.haml", :status => 403, :layout => false
  end

  def superadmin?
    current_user.superadmin?
  end

  def admin?
    current_user.superadmin? || current_user.admin?
  end

  def root_breadcrumb
    add_breadcrumb "Doomhub.com", :root_path, :force => true
  end

end
