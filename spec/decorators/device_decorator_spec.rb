require 'rails_helper'

RSpec.describe DeviceDecorator do
  let(:device) { build_stubbed(:device) }

  describe 'owner' do
    context 'when is set' do
      subject { DeviceDecorator.new(device).owner }
      it { is_expected.to eq(device.owner) }
    end

    context 'when is not set' do
      subject do
        device.owner = ''
        DeviceDecorator.new(device).owner
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'phone' do
    context 'when is set' do
      subject { DeviceDecorator.new(device).phone }
      it { is_expected.to eq(device.phone) }
    end

    context 'when is not set' do
      subject do
        device.phone = ''
        DeviceDecorator.new(device).phone
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'imei' do
    context 'when is set' do
      subject { DeviceDecorator.new(device).imei }
      it { is_expected.to eq(device.imei) }
    end

    context 'when is not set' do
      subject do
        device.imei = ''
        DeviceDecorator.new(device).imei
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'os' do
    context 'when is set' do
      subject { DeviceDecorator.new(device).os }
      it { is_expected.to eq(device.os) }
    end

    context 'when is not set' do
      subject do
        device.os = ''
        DeviceDecorator.new(device).os
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'model' do
    context 'when is set' do
      subject { DeviceDecorator.new(device).modelify }
      it { is_expected.to eq(device.model) }
    end

    context 'when is not set' do
      subject do
        device.model = ''
        DeviceDecorator.new(device).modelify
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'associated_at' do
    subject { DeviceDecorator.new(device).associated_at }

    it { is_expected.to have_css('span.timeago[datetime][title]')}
    it { is_expected.to match(/Associated/) }
  end

  describe 'delete_link' do
    let(:terminal) { build_stubbed(:terminal) }
    subject { DeviceDecorator.new(device).delete_link(terminal) }

    it { is_expected.to have_link('Delete', href: "/terminals/#{terminal.id}/pair_device") }
    it { is_expected.to have_css('a.btn.btn-danger') }
    it { is_expected.to have_css('a[data-method=delete]') }
    it { is_expected.to have_css('a[data-confirm="Are you sure?"]') }
  end
end
