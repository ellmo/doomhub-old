class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :root_breadcrumb
  before_filter :log_out_if_banned

  def log_out_if_banned
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:error] = "This account has been suspended...."
      root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root.to_s}/public/403", :status => 403, :layout => false, :handlers => [:haml]
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
