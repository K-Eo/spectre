require 'rails_helper'

describe ApplicationHelper do
  describe '#tab_item' do
    subject { helper.tab_item(name, options) }

    let(:name) { nil }
    let(:options) { nil }

    context 'when has no arguments' do
      it { expect { subject }.to raise_error("Can't create tab item") }
    end

    context 'when has arguments' do
      let(:name) { 'Foobar' }
      let(:options) { { url: '/foobar' } }

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Foobar', class: 'nav-link', href: '/foobar') }
    end

    context 'when controller name not includes url' do
      let(:name) { 'Test' }
      let(:options) { { url: '/' } }

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Test', class: 'nav-link', href: '/') }
      it { is_expected.not_to have_css('.active') }
    end

    context 'when controller name includes url' do
      let(:name) { 'Test' }
      let(:options) { { url: '/test' } }

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Test', href: '/test') }
      it { is_expected.to have_css('.nav-link.active') }
    end
  end

  describe '#flash_message' do
    context 'when has one' do
      subject do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar' })
        helper.flash_message
      end

      it { is_expected.to have_css('.flash-message.alert.alert-success.alert-dismissable.fade.show.my-0') }
      it { is_expected.to have_content('foobar') }
    end

    context 'when is empty' do
      it 'returns empty string' do
        expect(helper.flash_message).to eq('')
      end
    end

    context 'when has two or more' do
      subject do
        allow(helper).to receive(:flash).and_return({ notice: 'foobar', danger: 'foobaz' })
        helper.flash_message
      end

      it { is_expected.to have_css('.alert-success') }
      it { is_expected.to have_content('foobar') }
      it { is_expected.to have_css('.alert-danger') }
      it { is_expected.to have_content('foobaz') }
    end

    describe 'styling' do
      context 'when col is specified' do
        it 'returns alert with col wrapper' do
          allow(helper).to receive(:flash).and_return({ notice: 'foobar' })
          expect(helper.flash_message('col-10')).to have_css('.col-10')
        end
      end

      context 'when type is alert' do
        it 'returns alert-danger' do
          allow(helper).to receive(:flash).and_return({ alert: 'foobaz' })
          expect(helper.flash_message).to have_css('.alert-danger')
        end
      end

      context 'when type is notice' do
        it 'returns alert-success' do
          allow(helper).to receive(:flash).and_return({ notice: 'foobaz' })
          expect(helper.flash_message).to have_css('.alert-success')
        end
      end

      context 'when type is any other' do
        it 'returs given type' do
          allow(helper).to receive(:flash).and_return({ foo: 'bar' })
          expect(helper.flash_message).to have_css('.alert-foo')
        end
      end
    end
  end
end
