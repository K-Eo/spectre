require 'rails_helper'

describe Device do
  let(:device) { build(:device) }

  context 'when all properties are set' do
    let(:terminal) { create(:terminal) }

    it 'is valid' do
      device.terminal_id = terminal.id
      expect(device.valid?).to be_truthy
    end
  end

  describe 'Terminal' do
    context 'when terminal does not exist' do
      it 'is invalid' do
        expect(device.valid?).to be_falsey
      end
    end
  end

  describe 'IMEI' do
    context 'when is not preset' do
      it 'is invalid' do
        device.imei = nil
        expect(device.valid?).to be_falsey
      end
    end

    context 'when lenght is greater than 16' do
      it 'is invalid' do
        device.imei = 'a' * 17
        expect(device.valid?).to be_falsey
      end
    end
  end

  describe 'OS' do
    context 'when is not present' do
      it 'is invalid' do
        device.os = nil
        expect(device.valid?).to be_falsey
      end
    end
  end

  describe 'Phone' do
    context 'when is not present' do
      it 'is invalid' do
        device.phone = nil
        expect(device.valid?).to be_falsey
      end
    end

    context 'when length is greater than 20' do
      it 'is invalid' do
        device.phone = 'a' * 21
        expect(device.valid?).to be_falsey
      end
    end
  end

  describe 'Owner' do
    context 'when is not present' do
      it 'is invalid' do
        device.owner = nil
        expect(device.valid?).to be_falsey
      end
    end

    context 'when length is greater than 120' do
      it 'is invalid' do
        device.owner = 'a' * 121
        expect(device.valid?).to be_falsey
      end
    end
  end

  describe 'Model' do
    context 'when is not present' do
      it 'is invalid' do
        device.model = nil
        expect(device.valid?).to be_falsey
      end
    end
  end
end
