require 'rails_helper'

describe Api::V1::UsersController do
  render_views

  subject {
    request.headers['Authorization'] = "Token token=\"#{token}\""
    action
  }

  let(:user) { create(:user) }
  let(:token) { user.access_token }
  let(:params) { {} }
  let(:action) { get :show, params: params, as: :json }

  it { is_expected.to have_http_status(:ok) }
  it { is_expected.to have_attributes(content_type: 'application/json') }

  describe 'GET show' do
    context 'when access token is correct' do
      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to have_attributes(content_type: 'application/json') }

      it "return user info" do
        expect(subject.body).to match(/"email":"#{user.email}"/)
        expect(subject.body).to match(/"first_name":"#{user.first_name}"/)
        expect(subject.body).to match(/"last_name":"#{user.last_name}"/)
      end
    end

    context 'when access token is incorrect' do
      let(:token) { 'foobar' }
      it { is_expected.to have_http_status(:unauthorized) }
    end
  end

  describe 'PUT update' do
    let(:params) { { profile: { first_name: 'tom', last_name: 'jerry' } } }
    let(:action) { patch :update, params: params, as: :json }

    context 'when access token is correct' do
      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to have_attributes(content_type: 'application/json') }

      it "returns user info updated" do
        expect(subject.body).to match(/"first_name":"#{params[:profile][:first_name]}"/)
        expect(subject.body).to match(/"last_name":"#{params[:profile][:last_name]}"/)
      end
    end

    context 'when params not set' do
      let(:params) { {} }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end

    context 'when access token is incorrect' do
      let(:token) { '' }

      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end
