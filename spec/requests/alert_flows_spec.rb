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

  it 'creates alert event for each guard' do
    guard_in_range_delta = create(:user, lat: 17.2684659, lng: -97.6790971)
    guard_not_in_range = create(:user, lat: 17.245328, lng: -97.6950679)
    guard_in_range_echo = create(:user, lat: 17.2687989, lng: -97.6781947)

    user = create(:user, lat: 17.2681067, lng: -97.6782673)
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
    }.to change { AlertEvent.count }.by(2)

    alert = Alert.first
    expect(alert.has_guard?(guard_in_range_echo)).to be_truthy
    expect(alert.has_guard?(guard_in_range_delta)).to be_truthy
    expect(alert.has_guard?(guard_not_in_range)).to be_falsey
    expect(alert.has_guard?(user)).to be_falsey
  end

  it 'sends alert notifications for each guard' do
    ActiveJob::Base.queue_adapter = :test
    guard_in_range_delta = create(:user, lat: 17.2684659, lng: -97.6790971)
    guard_not_in_range = create(:user, lat: 17.245328, lng: -97.6950679)
    guard_in_range_echo = create(:user, lat: 17.2687989, lng: -97.6781947)

    user = create(:user, lat: 17.2681067, lng: -97.6782673)
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
    }.to have_enqueued_job.exactly(2)
  end
end
