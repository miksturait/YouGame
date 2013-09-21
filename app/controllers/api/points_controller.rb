class Api::PointsController < Api::BaseController
  def create
    points = @tracker.api_points_requests.create(params[:points])
    if points.valid?
      @tracker.update_attributes broadcast_required: true
      render json: {success: true}
    else
      render json: {errors: points.errors.full_messages}
    end
  end
end
