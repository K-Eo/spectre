require 'rails_helper'

describe TerminalsHelper do
  describe 'tab_item' do
    def go(name = '', url = '', active = false)
      link = %{<a class="nav-link#{ ' active' if active }" href="#{url}">#{name}</a>}
      expected = %{<li class="nav-item">#{link}</li>}
    end

    context 'when no arguments' do
      it 'renders default nav-link' do
        expect(helper.tab_item).to eq(go)
      end
    end

    context 'when link is inactive' do
      it 'renders nav-link' do
        expect(helper.tab_item('Test', '/')).to eq(go('Test', '/'))
      end
    end

    context 'when link is active' do
      it 'renders nav-link with active class' do
        expect(helper.tab_item('Test', 'test')).to eq(go('Test', 'test', true))
      end
    end
  end
end
