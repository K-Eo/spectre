require 'rails_helper'

RSpec.describe DeviceDecorator do
  context 'when props are not present' do
    subject { DeviceDecorator.new(@device) }

    before do
      @device = build_stubbed(:device, owner: '',
                                       phone: '',
                                       imei: '',
                                       os: '',
                                       model: '')
    end

    it { expect(subject.owner).to eq('no given') }
    it { expect(subject.phone).to eq('no given') }
    it { expect(subject.imei).to eq('no given') }
    it { expect(subject.os).to eq('no given') }
    it { expect(subject.modelify).to eq('no given') }
  end

  context 'when props are present' do
    subject { DeviceDecorator.new(@device) }

    before do
      @device = build_stubbed(:device)
    end

    it { expect(subject.owner).to eq(@device.owner) }
    it { expect(subject.phone).to eq(@device.phone) }
    it { expect(subject.imei).to eq(@device.imei) }
    it { expect(subject.os).to eq(@device.os) }
    it { expect(subject.modelify).to eq(@device.model) }
  end

  describe 'model' do
    before do
      @device = build_stubbed(:device)
    end

    describe 'associated_at' do
      subject { DeviceDecorator.new(@device).associated_at }

      it { is_expected.to have_css('span.timeago[datetime][title]')}
      it { is_expected.to match(/Associated/) }
    end

    describe 'delete_link' do
      let(:terminal) { build_stubbed(:terminal) }

      subject { DeviceDecorator.new(@device).delete_link(terminal) }

      it { is_expected.to have_link('Delete') }
      it { is_expected.to have_css("a[href=\"/terminals/#{terminal.id}/pair_device\"]") }
      it { is_expected.to have_css('a.btn.btn-danger') }
      it { is_expected.to have_css('a[data-method=delete]') }
      it { is_expected.to have_css('a[data-confirm="Are you sure?"]') }
    end
  end
end
