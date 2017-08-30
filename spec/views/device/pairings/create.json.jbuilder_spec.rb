require 'rails_helper'

describe 'device/pairings/create' do
  context 'when device is invalid' do
    let(:device) { build(:device, imei: '') }

    before do
      device.valid?
      assign(:device, device)
      render
      @response = JSON.parse(rendered)
    end

    it 'contains device properties' do
      expect(@response['imei']).to eq(device.imei)
      expect(@response['os']).to eq(device.os)
      expect(@response['phone']).to eq(device.phone)
      expect(@response['owner']).to eq(device.owner)
      expect(@response['model']).to eq(device.model)
    end

    it 'not contains created_at and updated_at' do
      expect(@response['created_at']).to be_nil
      expect(@response['updated_at']).to be_nil
    end

    it 'not contains access token' do
      expect(@response['access_token']).to be_nil
    end

    it 'contains errors' do
      expect(@response['errors']).not_to be_nil
    end
  end

  context 'when device is saved' do
    let(:device) { build(:device) }

    before do
      assign(:device, device)
      render
      @response = JSON.parse(rendered)
    end

    it 'contains device properties' do
      expect(@response['imei']).to eq(device.imei)
      expect(@response['os']).to eq(device.os)
      expect(@response['phone']).to eq(device.phone)
      expect(@response['owner']).to eq(device.owner)
      expect(@response['model']).to eq(device.model)
    end

    it 'not contains created_at and updated_at' do
      expect(@response['created_at']).to be_nil
      expect(@response['updated_at']).to be_nil
    end

    it 'not contains access token' do
      expect(@response['access_token']).to be_nil
    end

    it 'not contains errors' do
      expect(@response['errors']).to be_nil
    end
  end

  context 'when device is not saved' do
    let(:terminal) { create(:terminal) }
    let(:device) { create(:device, terminal_id: terminal.id) }

    before do
      terminal.set_current_device(device)
      assign(:device, device)
      assign(:terminal, terminal)
      render
      @response = JSON.parse(rendered)
    end

    it 'contains device properties' do
      expect(@response['imei']).to eq(device.imei)
      expect(@response['os']).to eq(device.os)
      expect(@response['phone']).to eq(device.phone)
      expect(@response['owner']).to eq(device.owner)
      expect(@response['model']).to eq(device.model)
    end

    it 'contains created_at and updated_at' do
      expect(@response['created_at']).to eq(device.created_at.iso8601(3))
      expect(@response['updated_at']).to eq(device.updated_at.iso8601(3))
    end

    it 'contains access token' do
      expect(@response['access_token']).to eq(terminal.access_token)
    end

    it 'not contains errors' do
      expect(@response['errors']).to be_nil
    end
  end
end
