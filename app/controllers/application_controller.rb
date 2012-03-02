class ApplicationController < ActionController::Base
  protect_from_forgery

  def superadmin?
    current_user.superadmin?
  end

  def admin?
    current_user.superadmin? || current_user.admin?
  end

end
