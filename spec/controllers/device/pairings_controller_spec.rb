require 'rails_helper'

describe Device::PairingsController do
  render_views
  let(:tenant) { create(:tenant) }

  describe 'POST create' do
    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    context 'when no valid' do
      let(:terminal) { create(:terminal) }

      def go(pairing_token = nil)
        token = terminal.pairing_token if pairing_token.nil?
        device = build(:device, imei: '', os: '', phone: '', owner: '', model: '')
        device = device.as_json.merge(pairing_token: token)
        post :create, params: { device: device }, as: :json
      end

      it 'returns unprocessable_entity' do
        go

        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns application/json' do
        go

        expect(response.content_type).to eq('application/json')
      end

      it 'returns errors' do
        go

        device = JSON.parse(response.body)
        expect(device['errors']).to_not be_nil
      end

      it 'returns original device' do
        go

        device = JSON.parse(response.body)
        expect(device['imei']).to eq('')
        expect(device['os']).to eq('')
        expect(device['phone']).to eq('')
        expect(device['owner']).to eq('')
        expect(device['model']).to eq('')
        expect(device['created_at']).to be_nil
        expect(device['updated_at']).to be_nil
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
        # expect(terminal.access_token).to be_nil
        expect(terminal.paired).to be_falsey
      end
    end

    context 'when device params is not present' do
      it 'returns bad_request' do
        post :create, as: :json

        expect(response).to have_http_status(:bad_request)
        expect(response.body).to eq('')
      end
    end

    context 'when pairing token is not found' do
      it 'returns not_found' do
        post :create, params: { device: { pairing_token: 'foobar' } }, as: :json

        expect(response).to have_http_status(:not_found)
        expect(response.body).to eq('')
      end
    end

    context 'when device is valid' do
      let(:terminal) { create(:terminal) }
      let(:device) { build(:device) }

      def go
        post :create, params: {
                        device: device.as_json.merge(pairing_token: terminal.pairing_token) },
                      as: :json
      end

      it 'returns created' do
        go

        expect(response).to have_http_status(:created)
      end

      it 'returns device with dates' do
        go

        actual_device = JSON.parse(response.body)
        expect(device[:imei]).to eq(actual_device['imei'])
        expect(device[:os]).to eq(actual_device['os'])
        expect(device[:phone]).to eq(actual_device['phone'])
        expect(device[:owner]).to eq(actual_device['owner'])
        expect(device[:model]).to eq(actual_device['model'])
        expect(actual_device['created_at']).not_to be_nil
        expect(actual_device['updated_at']).not_to be_nil
      end

      it 'generates access token' do
        go

        terminal.reload
        expect(terminal.access_token).to match(/[a-zA-Z0-9]+/)
      end

      it 'deletes pairing token' do
        go

        terminal.reload
        expect(terminal.pairing_token).to be_nil
      end

      it 'sets paired to true' do
        go

        terminal.reload
        expect(terminal.paired).to be_truthy
      end

      it 'sets device to current' do
        go

        saved_device = terminal.devices.find_by(imei: device[:imei])
        expect(saved_device.current).to be_truthy
      end

      it 'sets only one device as current' do
        go

        total = terminal.devices.where(current: true).count
        expect(total).to eq(1)
      end

      it 'adds device' do
        expect do
          go
        end.to change { Device.count }.by(1)
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      ActsAsTenant.current_tenant = tenant
    end

    after do
      ActsAsTenant.current_tenant = nil
    end

    context 'when access token not found' do
      let(:terminal) { create(:terminal, tenant_id: tenant.id) }

      it 'responds with bad_request' do
        delete :destroy, params: { token: 'foobar' }, as: :json

        expect(response).to have_http_status(:bad_request)
      end

      it 'does not add new device' do
        expect do
          delete :destroy, params: { token: 'foobar' }, as: :json
        end.to change { Device.count }.by(0)
      end
    end

    context 'when access token is found' do
      let(:terminal) { create(:terminal) }
      let(:device1) { create(:device, terminal_id: terminal.id) }
      let(:device2) { create(:device, terminal_id: terminal.id) }

      def go
        terminal.set_current_device(device2)
        delete :destroy, params: { token: terminal.access_token }, as: :json
      end

      it 'responds with ok' do
        go

        expect(response).to have_http_status(:ok)
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
