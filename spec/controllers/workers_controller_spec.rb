require 'rails_helper'

RSpec.describe WorkersController, type: :controller do
  render_views
  subject { login; action }

  let(:login) { sign_in create(:user) }
  let(:action) { get :index }

  describe 'GET index' do
    context 'when logged in' do
      it { is_expected.to have_http_status(:success) }
      it { is_expected.to render_template('workers/index') }
    end

    context 'when logged out' do
      let(:login) { nil }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  describe 'POST create' do
    let(:params) { { worker: attributes_for(:user) } }
    let(:action) { post :create, params: params }

    context 'when logged in' do
      context 'and when user is valid' do
        it { is_expected.to have_http_status(:success) }
        it { is_expected.to render_template('workers/index') }
        it { expect(subject.body).to match(/Invitation sent/) }
      end

      context 'when user is invalid' do
        let(:params) { { worker: attributes_for(:user, email: '') } }

        it { is_expected.to have_http_status(:success) }
        it { is_expected.to render_template('workers/index') }
      end

      context 'when user is not set' do
        let(:params) { {} }

        it { is_expected.to have_http_status(:success) }
        it { is_expected.to render_template('workers/index') }
        it { expect(subject.body).to match(/Email required/) }
      end
    end

    context 'when logged out' do
      let(:login) { nil }

      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end
end
