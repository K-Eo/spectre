require 'rails_helper'

describe 'layouts/pages' do
  subject {
    stub_template 'shared/_user_links' => user_links
    allow(view).to receive(:flash).and_return(flash)
    allow(view).to receive(:controller_name).and_return(controller_name)
    allow(view).to receive(:action_name).and_return(action_name)
    render
  }

  let(:user_links) { 'user links' }
  let(:flash) { Hash.new }
  let(:controller_name) { 'pages' }
  let(:action_name) { 'index' }

  describe 'head' do
    it { is_expected.to have_css('title', text: 'Spectre | Home', visible: false) }
    it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
    it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
    it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
  end

  describe 'nav' do
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'flash' do
    let(:flash) { { danger: 'danger alert' } }
    it { is_expected.to have_css('.flash-message') }
  end

  describe 'cta' do
    context 'when controller name is pages' do
      context 'and when action name is index' do
        it { is_expected.to have_css('div.jumbotron') }
      end

      context 'and when action_name is not index' do
        let(:controller_name) { 'pages' }
        let(:action_name) { 'show' }

        it { is_expected.not_to have_css('div.jumbotron') }
      end
    end

    context 'when controller name is not pages' do
      let(:controller_name) { 'dashboard' }
      it { is_expected.not_to have_css('div.jumbotron') }
    end
  end

  describe 'yield' do
    it 'yields' do
      stub_template 'shared/_user_links' => user_links
      render html: 'rspec__foobar', layout: 'layouts/pages'
      expect(rendered).to have_content('rspec__foobar')
    end
  end

  describe 'footer' do
    it { is_expected.to have_css('.footer') }
  end
end
