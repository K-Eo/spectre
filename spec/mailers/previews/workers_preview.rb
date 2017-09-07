# Preview all emails at http://localhost:3000/rails/mailers/workers
class WorkersPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/workers/credentials
  def credentials
    WorkersMailer.credentials(WorkerForm.new(email: 'foo@bar.com'))
  end

end
