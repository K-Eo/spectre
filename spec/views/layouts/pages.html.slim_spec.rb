require 'rails_helper'

describe 'layouts/pages' do
  describe 'head' do
    subject do
      render
      rendered
    end

    it { is_expected.to have_css('title', text: 'Spectre | Home', visible: false) }
    it { is_expected.to have_css('meta[charset="utf-8"]', visible: false) }
    it { is_expected.to have_css('meta[name="viewport"]', visible: false) }
    it { is_expected.to have_css('meta[content="width=device-width, initial-scale=1, shrink-to-fit=no"]', visible: false) }
  end

  describe 'body' do
    it 'renders navbar' do
      render
      expect(rendered).to have_css('nav#app-nav')
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: "danger alert" })
      render
      expect(rendered).to have_css('.flash-message')
    end

    describe 'cta' do
      context 'when controller name is pages' do
        context 'and when action name is index' do
          it 'renders marketing partial' do
            allow(view).to receive(:controller_name).and_return('pages')
            allow(view).to receive(:action_name).and_return('index')
            render
            expect(rendered).to have_css('div.jumbotron')
          end
        end

        context 'and when action_name is not index' do
          it 'renders without marketing partial' do
            allow(view).to receive(:controller_name).and_return('pages')
            allow(view).to receive(:action_name).and_return('show')
            render
            expect(rendered).not_to have_css('div.jumbotron')
          end
        end
      end

      context 'when controller name is not pages' do
        it 'renders without marketing partial' do
          render
          expect(rendered).not_to have_css('div.jumbotron')
        end
      end
    end

    it 'yields' do
      render html: 'rspec__foobar', layout: 'layouts/pages'
      expect(rendered).to have_content('rspec__foobar')
    end

    it 'renders footer' do
      render
      expect(rendered).to have_css('.footer')
    end
  end
end
