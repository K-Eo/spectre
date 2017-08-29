require 'rails_helper'

describe 'layouts/devise' do
  context 'renders head' do
    subject { rendered }

    before do
      render
    end

    it { is_expected.to match(%{Spectre | Accounts}) }
    it { is_expected.to match(%{charset="utf-8"}) }
    it { is_expected.to match(%{name="viewport"}) }
    it { is_expected.to match(%{content="width=device-width, initial-scale=1, shrink-to-fit=no"}) }
  end

  context 'body' do
    it 'renders nav' do
      render
      expect(rendered).to match(%{id="app-nav"})
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: 'foobar' })
      render
      expect(rendered).to match(%{class="flash-message.+"})
      expect(rendered).to match(%{col-10})
    end

    it 'yields' do
      render html: 'rspec__foobar', layout: 'layouts/devise'
      expect(rendered).to match(%{rspec__foobar})
    end
  end
end
