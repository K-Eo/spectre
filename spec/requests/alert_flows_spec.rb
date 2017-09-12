require 'rails_helper'

RSpec.describe 'Alert Creator', type: :request do
  it 'creates a new alert' do
    user = create(:user)
    post '/api/v1/auth', params: { email: user.email, password: 'password' }

    expect(response).to have_http_status(:ok)
    expect(response.content_type).to eq('application/json')
    expect(response.body).to match(/"access_token":"[a-zA-Z0-9]*"/)

    user.reload

    headers = {
      'Authorization' => "Token token=\"#{user.access_token}\""
    }

    expect {
      post '/api/v1/alerts', params: { alert: { text: 'foobar' } }, headers: headers
    }.to change { Alert.count }.by(1)

    expect(response).to have_http_status(:ok)
    expect(Alert.where(text: 'foobar').count).to eq(1)
  end
end
