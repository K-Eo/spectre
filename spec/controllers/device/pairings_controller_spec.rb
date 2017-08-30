require 'rails_helper'

describe Device::PairingsController do
  render_views

  describe 'POST create' do
    context 'when no valid params' do
      let(:terminal) { create(:terminal) }

      def go(pairing_token = nil)
        token = terminal.pairing_token if pairing_token.nil?
        device = build(:device, imei: '', os: '', phone: '', owner: '', model: '')
        device = device.as_json.merge(pairing_token: token)
        post :create, params: { device: device }
      end

      it 'returns unprocessable_entity' do
        go
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns application/json' do
        go
        expect(response.content_type).to eq('application/json')
      end

      it 'does not create new device' do
        expect do
          go
        end.to change { Device.count }.by(0)
      end

      it 'keeps the same pairing token' do
        token = terminal.pairing_token
        go(token)
        terminal.reload
        expect(terminal.pairing_token).to eq(token)
        expect(terminal.paired).to be_falsey
      end
    end

    context 'when device params is not present' do
      it 'returns bad_request' do
        post :create
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq('')
      end
    end

    context 'when pairing token is not found' do
      it 'returns not_found' do
        post :create, params: { device: { pairing_token: 'foobar' } }
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq('application/json')
        expect(response.body).to eq('')
      end
    end

    context 'when device is valid' do
      let(:terminal) { create(:terminal) }
      let(:device) { attributes_for(:device,
                                    :with_pairing_token,
                                    pairing_token: terminal.pairing_token) }

      def go
        post :create, params: { device: device }
      end

      it 'returns created' do
        go
        expect(response).to have_http_status(:created)
      end

      it 'returns application/json' do
        go
        expect(response.content_type).to eq('application/json')
      end

      it 'generates access token for terminal' do
        go
        terminal.reload
        expect(terminal.access_token).to match(/[a-zA-Z0-9]+/)
      end

      it 'deletes terminal pairing token' do
        go
        terminal.reload
        expect(terminal.pairing_token).to be_nil
      end

      it 'sets terminal paired status to true' do
        go
        terminal.reload
        expect(terminal.paired).to be_truthy
      end

      it 'sets device as current' do
        go
        saved_device = terminal.devices.find_by(imei: device[:imei])
        expect(saved_device.current).to be_truthy
      end

      it 'sets only one device as current' do
        go
        total = terminal.devices.where(current: true).count
        expect(total).to eq(1)
      end

      it 'creates device' do
        expect do
          go
        end.to change { Device.count }.by(1)
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when access token not found' do
      let(:terminal) { create(:terminal) }

      it 'responds with bad_request' do
        delete :destroy, params: { token: 'foobar' }
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json')
      end

      it 'does not add new device' do
        expect do
          delete :destroy, params: { token: 'foobar' }
        end.to change { Device.count }.by(0)
      end
    end

    context 'when access token is found' do
      let(:terminal) { create(:terminal) }
      let(:device1) { create(:device, terminal_id: terminal.id) }
      let(:device2) { create(:device, terminal_id: terminal.id) }

      def go
        terminal.set_current_device(device2)
        delete :destroy, params: { token: terminal.access_token }
      end

      it 'responds with ok' do
        go
        expect(response).to have_http_status(:ok)
      end

      it 'returns application/json' do
        go
        expect(response.content_type).to eq('application/json')
      end

      it 'sets current device to false' do
        go
        expect(terminal.devices.where(current: true).count).to eq(0)
      end

      it 'resets terminal' do
        go
        terminal.reload
        expect(terminal.access_token).to be_nil
        expect(terminal.pairing_token).to match(/[a-zA-Z0-9]*/)
        expect(terminal.paired).to be_falsey
      end
    end
  end
end
