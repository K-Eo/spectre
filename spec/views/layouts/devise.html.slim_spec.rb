require 'rails_helper'

describe 'layouts/devise' do
  subject {
    stub_template 'shared/_user_links' => 'user links'
    allow(view).to receive(:flash).and_return(flash)
    render
  }

  let(:flash) { Hash.new }

  describe 'head' do
    it { is_expected.to have_css('title', text: 'Spectre | Accounts', visible: false) }
    it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
    it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
    it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
  end

  describe 'nav' do
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'flash' do
    let(:flash) { { danger: 'foobar' } }

    it { is_expected.to have_css('.flash-message .col-10') }
  end

  describe 'yield' do
    it 'yields' do
      stub_template 'shared/_user_links' => 'user links'
      render html: 'rspec__foobar', layout: 'layouts/devise'
      expect(rendered).to match('rspec__foobar')
    end
  end
end
