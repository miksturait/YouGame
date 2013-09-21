class My::TrackersController < My::BaseController

  skip_filter :require_tracker_member, except: :show

  def show
    respond_to {|format| format.js { render json: @tracker.last_broadcast }}
  end

  def new
    if current_user.tracker_member.present? or current_user.assign_tracker_member
      redirect_to root_path
    else
      @member = Tracker::Member.new
    end
  end

  def create
    tracker_id = Tracker.find_by_url(params[:tracker_member][:tracker_url]).try :id
    @member = Tracker::Member.find_or_initialize_by_tracker_id_and_login(tracker_id, params[:tracker_member][:login])
    if @member.update_attributes(params[:tracker_member])
      current_user.update_attributes tracker_member_id: @member.id
      redirect_to my_screen_path, notice: t('my.trackers.create.success')
    else
      render :new
    end
  end

end
