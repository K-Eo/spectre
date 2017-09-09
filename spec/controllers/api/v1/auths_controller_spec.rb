require 'rails_helper'

describe Api::V1::AuthsController do
  render_views

  subject {
    action
  }

  let(:user) { create(:user) }
  let(:params) { { email: user.email, password: 'password' } }
  let(:action) { post :create, params: params, as: :json }

  it { is_expected.to have_http_status(:ok) }

  describe 'POST create' do
    context 'when params are valid' do
      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end

    context 'when password is incorrect' do
      let(:params) { { email: user.email, password: 'foobar' } }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end

    context 'when email does not exist' do
      let(:params) { { email: 'foo@mail.com', password: 'foobar' } }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end

    context 'when params are invalid' do
      let(:params) { { email: 'foo@bar.com', password: 'foobar' } }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end

    context 'when no params' do
      let(:params) { {} }

      it { is_expected.to have_http_status(:bad_request) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end
  end

  describe 'DELETE destroy' do
    let(:authorization) { "Token token=\"#{user.access_token}\"" }
    let(:params) { {} }
    let(:action) {
      request.headers['Authorization'] = authorization
      delete :destroy, params: params, as: :json
    }

    context 'when token exist' do
      it { is_expected.to have_http_status(:ok) }
    end

    context 'when token not exist' do
      let(:authorization) { '' }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
