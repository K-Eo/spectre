require 'rails_helper'

describe 'layouts/application' do
  describe 'head' do
    describe 'title' do
      context 'when is given' do
        it 'renders given name' do
          assign(:title, 'Foobar')
          render
          expect(rendered).to have_css('title', text: 'Foobar | Spectre', visible: false)
        end
      end

      context 'when is not given' do
        it 'renders only Spectre' do
          render
          expect(rendered).to have_css('title', text: 'Spectre', visible: false)
        end
      end
    end

    describe 'meta' do
      subject do
        render
        rendered
      end

      it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
      it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
      it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
    end
  end

  describe'body' do
    describe 'nav' do
      subject do
        render
        rendered
      end

      it { is_expected.to have_css('nav#app-nav') }
      it { is_expected.to have_css('div#app-tabs') }
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: "danger alert" })
      render
      expect(rendered).to have_css('.flash-message')
    end

    it 'yields' do
      render html: 'rspec__foobar', layout: 'layouts/application'
      expect(rendered).to have_content(%{rspec__foobar})
    end
  end
end
