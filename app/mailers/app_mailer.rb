class AppMailer < ActionMailer::Base
  default from: ENV["GMAIL_MAIL"], css: 'mail'
  layout 'mail'

  def update_exception(error)
    @error = error
    mail(to: ENV["SUPPORT_MAIL"], subject: "Exception during tracker update")
  end

  def weekly_update(update_worker)
    @update_worker = update_worker
    mail(to: update_worker.email, subject: "YouGame - #{update_worker.title}")
  end
end
