require 'rails_helper'

RSpec.describe WorkerForm, type: :model do
  subject { WorkerForm.new(email: email) }
  let(:email) { 'foo@bar.com' }

  describe 'email' do
    context 'when is not an email' do
      let(:email) { '' }
      it { expect(subject).to be_invalid }
    end

    context 'when email exists' do
      before do
        create(:user, email: 'foo@bar.com')
      end

      it { expect(subject).to be_invalid }
    end
  end

  describe '#submit' do
    context 'when email is valid' do
      it { expect(subject.submit).to be_truthy }
      it { expect { subject.submit }.to change { User.count }.by(1) }
      it { expect { subject.submit }.to change { ActionMailer::Base.deliveries.count }.by(1) }
    end
  end
end
