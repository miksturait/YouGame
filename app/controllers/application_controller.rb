class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :update_user_activity

  protected
  def require_tracker_member
    @tracker = current_user.tracker
    redirect_to new_my_tracker_path unless @tracker
  end

  def update_user_activity
    current_user.update_activity_stamp if current_user
  end

  def after_sign_in_path_for(user)
    my_screen_path
  end

end
