require 'rails_helper'

describe 'layouts/application' do
  subject {
    assign(:title, title)
    stub_template 'shared/_company_header' => header
    allow(view).to receive(:flash).and_return(flash)
    render
  }

  let(:title) { 'Foobar' }
  let(:header) { 'Company Header' }
  let(:flash) { Hash.new }

  describe 'title' do
    context 'when is set' do
      it { is_expected.to have_css('title', text: 'Foobar | Spectre', visible: false) }
    end

    context 'when is not set' do
      let(:title) { '' }
      it { is_expected.to have_css('title', text: 'Spectre', visible: false) }
    end
  end

  describe 'meta' do
    it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
    it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
    it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
  end

  describe 'nav' do
    it { is_expected.to have_css('nav#app-nav') }
  end

  describe 'flash' do
    context 'when is set' do
      let(:flash) { { danger: "danger alert" } }
      it { is_expected.to have_css('.flash-message') }
    end

    context 'when is not set' do
      it { is_expected.not_to have_css('.flash-message') }
    end
  end

  describe 'tabs' do
    it { is_expected.to have_css('nav#app-tabs') }
  end

  describe 'yield' do
    it 'returns content' do
      stub_template 'shared/_company_header' => header
      render html: 'rspec__foobar', layout: 'layouts/application'
      expect(rendered).to have_content('rspec__foobar')
    end
  end
end
