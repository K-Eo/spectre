require 'rails_helper'

describe Api::V1::UsersController do
  render_views

  subject {
    request.headers['Authorization'] = "Token token=\"#{token}\""
    action
  }

  let(:token) { user.access_token }
  let(:user) { create(:user) }
  let(:params) { {} }
  let(:action) { get :show, params: params, as: :json }

  it { is_expected.to have_http_status(:ok) }
  it { is_expected.to have_attributes(content_type: 'application/json') }

  describe 'GET show' do
    context 'when access token is set' do
      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to have_attributes(content_type: 'application/json') }
    end

    context 'when access token is wrong' do
      let(:token) { 'foobar' }
      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
