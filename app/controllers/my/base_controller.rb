class My::BaseController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_tracker_member

end
