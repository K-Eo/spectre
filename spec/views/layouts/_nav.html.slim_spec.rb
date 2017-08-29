require 'rails_helper'

describe 'layouts/_nav' do
  before do
    render
  end

  it 'renders wrapper' do
    expect(rendered).to match(%{nav class="navbar navbar-expand-md navbar-dark bg-dark"})
  end

  context 'when user logged in' do
    it 'renders brand link to terminals path' do
      allow(view).to receive(:user_signed_in?).and_return(true)
      render
      expect(rendered).to match(%{<a class="navbar-brand" href="/terminals">Spectre</a>})
    end
  end

  context 'when user logged out' do
    it 'renders brand link to root path' do
      allow(view).to receive(:user_signed_in?).and_return(false)
      render
      expect(rendered).to match(%{<a class="navbar-brand" href="/">Spectre</a>})
    end
  end

  it 'renders user links' do
    render
    expect(rendered).to match(%{id="user-links"})
  end
end
