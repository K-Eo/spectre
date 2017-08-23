require 'rails_helper'

describe DeviceEmail do
  let (:device_email) { build(:device_email) }

  context 'when email is present' do
    it 'is valid' do
      expect(device_email.valid?).to be_truthy
    end
  end

  context 'when email is not present' do
    it 'is not valid' do
      device_email.email = nil
      expect(device_email.valid?).to be_falsey
    end
  end

  context 'when email is invalid' do
    it 'is not valid' do
      device_email.email = 'foobar'
      expect(device_email.valid?).to be_falsey
    end
  end
end
