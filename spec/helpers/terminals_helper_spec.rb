require 'rails_helper'

describe TerminalsHelper do
  describe '#tab_item' do
    context 'when has no arguments' do
      subject do
        helper.tab_item
      end

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('', class: 'nav-link', href: '') }
    end

    context 'when has arguments' do
      subject do
        helper.tab_item('Foobar', '/foobar')
      end

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Foobar', class: 'nav-link', href: '/foobar') }
    end

    context 'when controller name not includes url' do
      subject do
        helper.tab_item('Test', '/')
      end

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Test', class: 'nav-link', href: '/') }
      it { is_expected.not_to have_css('.active') }
    end

    context 'when controller name includes url' do
      subject do
        helper.tab_item('Test', '/test')
      end

      it { is_expected.to have_css('li.nav-item') }
      it { is_expected.to have_link('Test', class: 'nav-link active', href: '/test') }
      it { is_expected.to have_css('.active') }
    end
  end
end
