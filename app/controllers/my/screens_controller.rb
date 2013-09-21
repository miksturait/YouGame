class My::ScreensController < My::BaseController

  prepend_view_path 'app/views/shared/screens'

  def show
    @tracked_users_ids = current_user.tracker.visible_members.map(&:id).to_json
    @broadcast = @tracker.last_broadcast.present? ? @tracker.last_broadcast : @tracker.make_broadcast_data
    @broadcast.delete('audits')
  end
end
