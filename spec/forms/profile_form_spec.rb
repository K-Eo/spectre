require 'rails_helper'

describe ProfileForm, type: :model do
  subject {
    ProfileForm.new(current_user).update(params)
  }

  let(:current_user) { create(:user) }
  let(:first_name) { 'foo' }
  let(:last_name) { 'bar' }
  let(:params) {
    ActionController::Parameters.new({
      profile: { first_name: first_name, last_name: last_name }
    })
  }


  describe '#update' do

    it { is_expected.to be_truthy }

    context 'when params is nil' do
      let(:params) { nil }

      it { is_expected.to be_falsey }
    end

    describe 'first_name' do
      context 'when is too long' do
        let(:first_name) { 'a' * 256 }
        it { is_expected.to be_falsey }
      end

      context 'when format is wrong' do
        let(:first_name) { '!@##$%^^&*()12' }
        it { is_expected.to be_falsey }
      end
    end

    describe 'last_name' do
      context 'when is too long' do
        let(:last_name) { 'a' * 256 }
        it { is_expected.to be_falsey }
      end

      context 'when format is wrong' do
        let(:last_name) { '!@##$%^^&*()12' }
        it { is_expected.to be_falsey }
      end
    end
  end
end
