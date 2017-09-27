module MailerHelper
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def mailer_size
    ActionMailer::Base.deliveries.size
  end

  def reset_emails
    ActionMailer::Base.deliveries = []
  end
end
