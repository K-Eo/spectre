require 'rails_helper'

describe 'layouts/_footer' do
  before do
    render
  end

  it 'renders footer' do
    expect(rendered).to match(%{footer class="footer"})
  end

  it 'renders copyright' do
    expect(rendered).to match(%{&copy; Spectre 2017})
  end
end
