class WorkersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.workers_mailer.credentials.subject
  #
  def credentials(email, password)
    @email = email
    @password = password

    mail to: worker.email
  end
end
