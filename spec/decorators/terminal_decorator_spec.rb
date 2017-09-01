require 'rails_helper'

RSpec.describe TerminalDecorator do

  describe 'props' do
    subject { TerminalDecorator.new(@terminal) }

    context 'when set' do
      before do
        @terminal = build_stubbed(:terminal, pairing_token: 'token')
      end

      it { expect(subject.name).to eq(@terminal.name) }
      it { expect(subject.qr_image).to have_css('img[src][title="QR Image"]') }
    end

    context 'when not set' do
      before do
        @terminal = build_stubbed(:terminal, name: '')
      end

      it { expect(subject.name).to eq('no given') }
      it { expect(subject.qr_image).to have_css('span', text: 'Can\'t cook QR Image') }
    end
  end

  describe 'model' do
    before do
      @terminal = build_stubbed(:terminal)
    end

    describe 'created_at' do
      subject { TerminalDecorator.new(@terminal).created_at }

      it { is_expected.to have_css('span.timeago[datetime][title]') }
      it { is_expected.to match(/#[0-9]+\s•\screated\s/) }
    end

    describe 'delete_link' do
      subject { TerminalDecorator.new(@terminal).delete_link }

      it { is_expected.to have_link('Delete', href: "/terminals/#{@terminal.id}") }
      it { is_expected.to have_css('a.btn.btn-danger') }
      it { is_expected.to have_css('a[data-method=delete]') }
      it { is_expected.to have_css('a[data-confirm="Are you sure?"]') }
    end

    describe 'edit_link' do
      subject { TerminalDecorator.new(@terminal).edit_link }
      it { is_expected.to have_link('Edit', href: "/terminals/#{@terminal.id}/edit") }
      it { is_expected.to have_css('a.btn.btn-success') }
    end
  end

end
