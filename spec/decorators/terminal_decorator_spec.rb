require 'rails_helper'

RSpec.describe TerminalDecorator do
  let(:terminal) { build_stubbed(:terminal) }

  describe 'icon' do
    context 'when terminal is paired' do
      subject do
        terminal.paired = true
        TerminalDecorator.new(terminal).icon(class: 'foobar')
      end

      it { is_expected.to have_css('svg.octicon.octicon-device-mobile') }
      it { is_expected.to have_css('svg.foobar') }
    end

    context 'when terminal is not paired' do
      subject do
        TerminalDecorator.new(terminal).icon(class: 'foobar')
      end

      it { is_expected.to have_css('svg.octicon.octicon-info') }
      it { is_expected.to have_css('svg.foobar') }
    end
  end

  describe 'name' do
    context 'when set' do
      subject { TerminalDecorator.new(terminal).name }
      it { is_expected.to eq(terminal.name) }
    end

    context 'when not set' do
      subject do
        terminal.name = ''
        TerminalDecorator.new(terminal).name
      end
      it { is_expected.to eq('no given') }
    end
  end

  describe 'pairing_token' do
    context 'when set' do
      subject do
        terminal.pairing_token = 'token'
        TerminalDecorator.new(terminal).qr_image
      end
      it { is_expected.to have_css('img[src][title="QR Image"]') }
    end

    context 'when not set' do
      subject do
        terminal.pairing_token = ''
        TerminalDecorator.new(terminal).qr_image
      end
      it { is_expected.to have_css('span', text: 'Can\'t cook QR Image') }
    end
  end

  describe 'created_at' do
    subject { TerminalDecorator.new(terminal).created_at }
    it { is_expected.to have_css('span.timeago[datetime][title]') }
    it { is_expected.to match(/#[0-9]+\s•\screated\s/) }
  end

  describe 'delete_link' do
    subject { TerminalDecorator.new(terminal).delete_link }

    it { is_expected.to have_link('Delete', href: "/terminals/#{terminal.id}") }
    it { is_expected.to have_css('a.btn.btn-danger') }
    it { is_expected.to have_css('a[data-method=delete]') }
    it { is_expected.to have_css('a[data-confirm="Are you sure?"]') }
  end

  describe 'edit_link' do
    subject { TerminalDecorator.new(terminal).edit_link }
    it { is_expected.to have_link('Edit', href: "/terminals/#{terminal.id}/edit") }
    it { is_expected.to have_css('a.btn.btn-success') }
  end
end
