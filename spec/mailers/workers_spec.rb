require "rails_helper"

RSpec.describe WorkersMailer, type: :mailer do
  describe "credentials" do
    let(:worker) { WorkerForm.new(email: 'foo@mail.com') }
    let(:mail) { WorkersMailer.credentials(worker) }

    it "renders the headers" do
      expect(mail.subject).to eq("Credentials")
      expect(mail.to).to eq(["foo@mail.com"])
      expect(mail.from).to eq(["spectre@support.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(worker.password)
    end
  end

end
