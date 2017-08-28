require 'rails_helper'

describe Tenant do
  let(:tenant) { build(:tenant) }

  before(:each) do
    ActsAsTenant.current_tenant = nil
  end
  
  describe 'Name' do
    context 'when is not present' do
      it 'is invalid' do
        tenant.name = nil
        expect(tenant.valid?).to be_falsey
      end
    end

    context 'when length is greater than 255' do
      it 'is invalid' do
        tenant.name = 'a' * 256
        expect(tenant.valid?).to be_falsey
      end
    end
  end

  describe 'Organization' do
    context 'when is not present' do
      it 'is invalid' do
        tenant.organization = nil
        expect(tenant.valid?).to be_falsey
      end
    end

    context 'when length is greater than 50' do
      it 'is invalid' do
        tenant.organization = 'a' * 51
        expect(tenant.valid?).to be_falsey
      end
    end

    context 'when already exists' do
      it 'is invalid' do
        tenant2 = create(:tenant)
        current_tenant = build(:tenant, organization: tenant2.organization)
        expect(current_tenant.valid?).to be_falsey
      end
    end
  end
end
