require 'rails_helper'

describe 'layouts/_tabs' do
  subject { rendered }

  before do
    render
  end

  describe 'wrapper' do
    it { is_expected.to have_css('div#app-tabs') }
  end

  describe 'items' do
    it { is_expected.to have_link('Terminal', href: '/terminals', class: 'nav-link') }
  end
end
