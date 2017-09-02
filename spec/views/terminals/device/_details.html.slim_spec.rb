require 'rails_helper'

describe 'terminals/device/_details' do
  let(:device) { build_stubbed(:device) }
  subject do
    assign(:device, device.decorate)
    render template: 'terminals/device/_details',
           locals: { terminal: build_stubbed(:terminal).decorate }
    rendered
  end

  describe 'head' do
    it { is_expected.to have_css('h5', text: 'Device Details') }
    it { is_expected.to have_css('p.text-muted', text: /Associated/) }
    it { is_expected.to have_css('span.timeago') }
  end

  describe 'owner' do
    it { is_expected.to have_css('strong', text: 'Owner') }
    it { is_expected.to have_css('p', text: device.owner) }
  end

  describe 'phone' do
    it { is_expected.to have_css('strong', text: 'Phone') }
    it { is_expected.to have_css('p', text: device.phone) }
  end

  describe 'imei' do
    it { is_expected.to have_css('strong', text: 'IMEI') }
    it { is_expected.to have_css('p', text: device.imei) }
  end

  describe 'os' do
    it { is_expected.to have_css('strong', text: 'OS') }
    it { is_expected.to have_css('p', text: device.os) }
  end

  describe 'model' do
    it { is_expected.to have_css('strong', text: 'Model') }
    it { is_expected.to have_css('p', text: device.model) }
  end

  describe 'actions' do
    it { is_expected.to have_link('Delete') }
  end
end
