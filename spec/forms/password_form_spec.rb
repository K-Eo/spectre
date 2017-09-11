require 'rails_helper'

describe PasswordForm, type: :model do
  subject {
    PasswordForm.new(current_user).update(params)
  }

  let(:current_user) { create(:user) }
  let(:password) { 'qwerty'}
  let(:password_confirmation) { 'qwerty'}
  let(:current_password) { 'password'}
  let(:params) {
    ActionController::Parameters.new({
      user: { password: password,
              password_confirmation: password_confirmation,
              current_password: current_password }
    })
  }

  describe '#update' do
    context 'when user params is set' do
      it { is_expected.to be_truthy }
    end

    context 'when user params is not set' do
      let(:params) { nil }

      it { is_expected.to be_falsey }
    end
  end

end
