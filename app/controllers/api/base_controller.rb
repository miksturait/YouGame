class Api::BaseController < ApplicationController
  before_filter :require_tracker

  private
  def require_tracker
    @tracker = Tracker.find_by_api_key(params[:api_key])
    render json: { errors: ['invalid api key']} unless @tracker
  end
end
