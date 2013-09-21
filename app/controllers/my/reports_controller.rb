class My::ReportsController < My::BaseController
  def new
    @reports = projects.map do |project|
      project.current_report || project.reports.build
    end
    @current_report_date = current_report_date
  end

  def create
    report = project.current_report || project.reports.build
    report.tracker_id   ||= @tracker.id
    report.creator_id   ||= creator_id
    report.report_date  ||= current_report_date.to_s
    report.update_attributes(params[:tracker_report])
    render nothing: true
  end

  private
  def projects
    @projects = @tracker.projects.where(lead_id: creator_id)
  end

  def project
    @project = @tracker.projects.find(params[:tracker_report][:project_id])
  end

  def creator_id
    current_user.tracker_member_id
  end

  def current_report_date
    Date.today.beginning_of_week
  end
end
