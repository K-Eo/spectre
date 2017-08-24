require 'rails_helper'

describe Terminal do
  let(:terminal) { create(:terminal) }

  context 'when all properties are set' do
    it 'is valid'  do
      expect(terminal.valid?).to be_truthy
    end
  end

  describe 'Tenant' do
    context 'when tenant does not exist' do
      it 'is invalid' do
        ActsAsTenant.current_tenant = nil
        terminal2 = build(:terminal)
        expect(terminal2.valid?).to be_falsey
      end
    end
  end

  describe 'Name' do
    context 'when is not present' do
      it 'is invalid' do
        terminal.name = nil
        expect(terminal.valid?).to be_falsey
      end
    end

    context 'when length is greater than 255' do
      it 'is invalid' do
        terminal.name = 'a' * 256
        expect(terminal.valid?).to be_falsey
      end
    end
  end

  context 'after_create' do
    it 'generates pairing_token' do
      terminal.save
      expect(terminal.pairing_token).to match(/[a-zA-Z0-9]{24}/)
    end

    it 'sets paired to false' do
      terminal.save
      expect(terminal.paired?).to be_falsey
    end

    it 'generates access_token' do
      terminal.save
      expect(terminal.access_token).to match(/[a-zA-Z0-9]{24}/)
    end
  end
end
