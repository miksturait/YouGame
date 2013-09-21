class Admin::CustomAchievementsController < Admin::BaseController
  inherit_resources
  belongs_to :tracker
  defaults resource_class: Achievement::Custom

  def create
    create! do |success, failure|
      success.html { redirect_to admin_custom_achievements_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to admin_custom_achievements_path }
    end
  end

  def grant
    resource.attributes = params[:achievement_custom]
    ids = resource.grant_member_ids
    resource.grant(@tracker.visible_members.where{id.in ids}) if resource.has_points?
    @tracker.update_attributes broadcast_required: true
    redirect_to admin_custom_achievements_path, notice: t('admin.custom_achievements.grant.achivement_unlocked')
  end
end
