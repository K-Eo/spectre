require 'rails_helper'

describe 'layouts/_user_links' do
  subject { rendered }

  describe 'wrapper' do
    before do
      render
    end

    it { is_expected.to have_css('div#user-links') }
  end

  describe 'items' do
    context 'when logged in' do
      before do
        allow(view).to receive_message_chain('current_user.is_a?') { false }
        render
      end

      it { is_expected.to have_link('Sign Out', href: '/user/sign_out') }
      it { is_expected.to have_css('a[data-method="delete"]', text: 'Sign Out') }
      it { is_expected.not_to have_link('Sign In') }
      it { is_expected.not_to have_link('Sign Up') }
    end
  end

  context 'when user logged out' do
    before do
      allow(view).to receive_message_chain('current_user.is_a?') { true }
      render
    end

    it { is_expected.to have_link('Sign In', href: '/user/sign_in') }
    it { is_expected.to have_link('Sign Up', href: '/user/sign_up') }
    it { is_expected.not_to have_link('Sign Out') }
  end
end
