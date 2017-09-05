require 'rails_helper'

describe 'layouts/_nav' do
  subject { rendered }

  before do
    render
  end

  describe 'wrapper' do
    it { is_expected.to have_css('nav.navbar.navbar-expand-md.navbar-dark.bg-dark') }
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'brand link' do
    context 'when user logged out' do
      it 'renders link to root path' do
        allow(view).to receive(:user_signed_in?).and_return(false)
        render
        expect(rendered).to have_link('Spectre', href: '/', class: 'navbar-brand')
      end
    end
  end

  describe 'user links' do
    it { is_expected.to have_css('div#user-links') }
  end
end
