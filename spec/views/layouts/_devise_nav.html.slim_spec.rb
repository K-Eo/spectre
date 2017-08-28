require 'rails_helper'

describe 'layouts/_devise_nav' do
  include Devise::Test::ControllerHelpers

  before do
    render
  end

  it 'renders nav wrapper' do
    expect(rendered).to match(%{nav class="navbar navbar-expand-md navbar-dark px-0"})
  end

  it 'renders brand link' do
    expect(rendered).to match(%{<a class="navbar-brand" href="/">Spectre</a>})
  end

  context 'when user logged in' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(true)
    end

    it 'renders sign out link' do
      render
      expect(rendered).to match(%{data-method="delete" href="/user/sign_out"})
      expect(rendered).to match(%{Sign Out})
    end
  end

  context 'when user logged out' do
    before do
      allow(view).to receive(:user_signed_in?).and_return(false)
    end

    it 'renders sign in link' do
      render
      expect(rendered).to match(%{href="/user/sign_in"})
      expect(rendered).to match(%{Sign In})
    end

    it 'render sign up link' do
      render
      expect(rendered).to match(%{href="/user/sign_up"})
      expect(rendered).to match(%{Sign Up})
    end
  end
end
