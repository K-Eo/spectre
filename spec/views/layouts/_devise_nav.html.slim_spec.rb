require 'rails_helper'

describe 'layouts/_devise_nav' do
  before do
    render
  end

  it 'renders nav wrapper' do
    expect(rendered).to match(%{nav class="navbar navbar-expand-md navbar-dark px-0"})
  end

  it 'renders brand link' do
    expect(rendered).to match(%{<a class="navbar-brand" href="/">Spectre</a>})
  end
end
