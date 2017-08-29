require 'rails_helper'

describe 'layouts/_tabs' do
  it 'renders tabs wrapper' do
    render
    expect(rendered).to match(%{id="app-tabs"})
  end

  it 'renders terminals link' do
    render
    expect(rendered).to match(%{<a class="nav-link" href="/terminals">Terminals</a>})
  end
end
