require 'rails_helper'

describe 'layouts/application' do
  context 'head' do
    before do
      render
    end

    context 'title' do
      context 'when is given' do
        it 'renders given name' do
          assign(:title, 'Foobar')
          render
          expect(rendered).to match(%{<title>Foobar | Spectre</title>})
        end
      end

      context 'when is not given' do
        it 'renders only Spectre' do
          expect(rendered).to match(%{<title>Spectre</title>})
        end
      end
    end

    it 'renders utf-8' do
      expect(rendered).to match(%{charset="utf-8"})
    end

    it 'renders viewport meta' do
      expect(rendered).to match(%{name="viewport"})
    end

    it 'renders bootstrap resposive settings' do
      expect(rendered).to match(%{content="width=device-width, initial-scale=1, shrink-to-fit=no"})
    end
  end

  context 'body' do
    it 'renders nav' do
      render
      expect(rendered).to match(%{id="app-nav"})
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: "danger alert" })
      render

      expect(rendered).to match(%{class="flash-message.+"})
    end

    it 'renders tabs' do
      render
      expect(rendered).to match(%{id="app-tabs"})
    end

    it 'yields' do
      render html: 'rspec__foobar', layout: 'layouts/application'
      expect(rendered).to match(%{rspec__foobar})
    end
  end
end
