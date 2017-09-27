# Preview all emails at http://localhost:3000/rails/mailers/workers
class WorkersMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/workers/credentials

  def credentials
    WorkersMailer.credentials("foo@bar.com", "worker password")
  end
end
