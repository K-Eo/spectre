require 'rails_helper'

describe Api::V1::AlertsController do
  render_views

  subject {
    request.headers['Authorization'] = "Token token=\"#{token}\""
    action
  }

  let(:user) { create(:user) }
  let(:token) { user.access_token }
  let(:params) { {} }
  let(:action) { get :index, params: params, as: :json }

  it { is_expected.to have_http_status(:ok) }
  it { is_expected.to have_attributes(content_type: 'application/json') }

  describe 'POST create' do
    let(:params) { { alert: { text: 'foobar' } } }
    let(:action) { post :create, params: params, as: :json }

    context 'when text is set' do
      it { is_expected.to have_http_status(:ok) }
    end

    context 'when text is not set' do
      let(:params) { { alert: { text: '' } } }

      it { is_expected.to have_http_status(:ok) }
    end

    context 'when params is not set' do
      let(:params) { {} }

      it { is_expected.to have_http_status(:ok) }
    end
  end
end
