require 'rails_helper'

describe 'layouts/_devise_nav' do
  subject {
    stub_template 'shared/_user_links' => '<div id="user-links">User Links</div>'
    render
  }

  describe 'navbar' do
    it { is_expected.to have_css('.navbar.navbar-expand-md.navbar-dark.px-0') }
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'navbar brand' do
    it { is_expected.to have_css('a.navbar-brand') }
    it { is_expected.to have_link('Spectre', href: '/') }
  end

  describe 'user links' do
    it { is_expected.to have_css('div#user-links') }
  end
end
