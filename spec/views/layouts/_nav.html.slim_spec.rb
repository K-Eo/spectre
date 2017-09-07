require 'rails_helper'

describe 'layouts/_nav' do
  subject {
    allow(view).to receive(:current_user).and_return(user)
    render
  }

  let(:user) { build_stubbed(:user) }

  describe 'wrapper' do
    it { is_expected.to have_css('nav.navbar.navbar-expand-md.navbar-dark.bg-dark') }
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'brand link' do
    context 'when logged in' do
      it { is_expected.to have_link('Spectre', href: '/dashboard', class: 'navbar-brand') }
    end

    context 'when logged out' do
      let(:user) { GuestUser.new }
      it { is_expected.to have_link('Spectre', href: '/', class: 'navbar-brand') }
    end
  end

  describe 'user links' do
    it { is_expected.to have_css('ul#user-links') }
  end
end
