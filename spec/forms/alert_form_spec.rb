require 'rails_helper'

describe AlertForm, type: :model do
  subject { AlertForm.new(current_user).update(params) }
  let(:current_user) { create(:user) }
  let(:text) { 'foobar' }
  let(:params) {
    ActionController::Parameters.new({
      alert: { text: text }
    })
  }

  describe '#update' do
    context 'when alert is valid' do
      it { is_expected.to be_truthy }

      it 'creates new alert' do
        form = AlertForm.new(current_user)
        expect {
          form.update(params)
        }.to change { Alert.count }.by(1)
      end
    end
  end
end
