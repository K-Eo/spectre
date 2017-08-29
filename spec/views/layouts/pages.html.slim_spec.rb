require 'rails_helper'

describe 'layouts/pages' do
  context 'head' do
    before do
      render
    end

    it 'renders page name' do
      expect(rendered).to match(%{Spectre | Home})
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
    before do
      render
    end

    it 'renders navbar' do
      expect(rendered).to match(%{id="app-nav"})
    end

    it 'renders flash messages' do
      allow(view).to receive(:flash).and_return({ danger: "danger alert" })
      render

      expect(rendered).to match(%{class="flash-message.+"})
    end

    context 'cta' do
      context 'when controller_name is pages' do
        context 'and when action_name is index' do
          it 'renders marketing partial' do
            allow(view).to receive(:controller_name).and_return('pages')
            allow(view).to receive(:action_name).and_return('index')
            render
            expect(rendered).to match(%{class="jumbotron"})
          end
        end

        context 'and when action_name is not index' do
          it 'renders without marketing partial' do
            allow(view).to receive(:controller_name).and_return('pages')
            allow(view).to receive(:action_name).and_return('show')
            render
            expect(rendered).not_to match(%{class="jumbotron"})
          end
        end
      end

      context 'when controller name is not pages' do
        it 'renders without marketing partial' do
          render
          expect(rendered).not_to match(%{class="jumbotron"})
        end
      end
    end

    it 'yields' do
      render plain: 'foobar', layout: 'layouts/pages'
      expect(rendered).to match(%{foobar})
    end

    it 'renders footer' do
      expect(rendered).to match('class="footer"')
    end
  end
end
