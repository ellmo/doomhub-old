class ApplicationController < ActionController::Base
  protect_from_forgery

  add_breadcrumb "DoomHub.com", :root_path

  def superadmin?
    current_user.superadmin?
  end

  def admin?
    current_user.superadmin? || current_user.admin?
  end

end
