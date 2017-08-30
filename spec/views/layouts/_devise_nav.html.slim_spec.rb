require 'rails_helper'

describe 'layouts/_devise_nav' do
  subject { rendered }

  before do
    render
  end

  context 'navbar' do
    it { is_expected.to have_css('.navbar.navbar-expand-md.navbar-dark.px-0') }
    it { is_expected.to have_css('nav#app-nav') }
  end

  context 'navbar brand' do
    it { is_expected.to have_css('a.navbar-brand') }
    it { is_expected.to have_link('Spectre', href: '/') }
  end

  context 'user links' do
    it { is_expected.to have_css('div#user-links') }
  end
end
