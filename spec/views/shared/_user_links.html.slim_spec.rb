require 'rails_helper'

describe 'shared/_user_links' do
  subject {
    allow(view).to receive(:gravatar).and_return('gravatar')
    allow(view).to receive(:current_user).and_return(user)
    render
  }

  let(:user) { build_stubbed(:user) }

  describe 'wrapper' do
    context 'when logged in' do
      it { is_expected.to have_css('ul#user-links') }
    end

    context 'when logged out' do
      let(:user) { GuestUser.new }
      it { is_expected.to have_css('div#user-links') }
    end
  end

  describe 'options' do
    context 'when logged in' do
      it { is_expected.to have_link('Salir', href: '/user/sign_out') }
      it { is_expected.to have_css('a[data-method="delete"]', text: 'Salir') }
      it { is_expected.not_to have_link('Sign In') }
      it { is_expected.not_to have_link('Sign Up') }
    end

    context 'when user logged out' do
      let(:user) { GuestUser.new }
      it { is_expected.to have_link('Sign In', href: '/user/sign_in') }
      it { is_expected.to have_link('Sign Up', href: '/user/sign_up') }
      it { is_expected.not_to have_link('Salir') }
    end
  end
end
