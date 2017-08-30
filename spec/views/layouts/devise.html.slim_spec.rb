require 'rails_helper'

describe 'layouts/devise' do
  describe 'head' do
    subject do
      render
      rendered
    end

    it { is_expected.to have_css('title', text: 'Spectre | Accounts', visible: false) }
    it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
    it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
    it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
  end

  describe 'body' do
    it 'renders nav' do
      render
      expect(rendered).to have_css('nav#app-nav')
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: 'foobar' })
      render
      expect(rendered).to have_css('.flash-message .col-10')
    end

    it 'yields' do
      render html: 'rspec__foobar', layout: 'layouts/devise'
      expect(rendered).to match('rspec__foobar')
    end
  end
end
