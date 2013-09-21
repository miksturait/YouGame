class Admin::SettingsController < Admin::BaseController

  def create
    notice = if params[:make_update]
      @tracker.make_full_update
      t('my.trackers.full_update.success')
    elsif params[:generate_api_key]
      @tracker.generate_api_key!
      t('my.trackers.generate_api_key.success')
    end
    redirect_to admin_setting_path, notice: notice
  end

  def update
    message = (t('my.trackers.update.success') if @tracker.update_attributes(params[:tracker]))
    redirect_to admin_setting_path, notice: message
  end
end
