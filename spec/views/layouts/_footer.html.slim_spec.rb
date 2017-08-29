require 'rails_helper'

describe 'layouts/_footer' do
  subject { rendered }

  before do
    render
  end

  describe 'footer' do
    it { is_expected.to have_css('footer.footer') }
  end

  describe 'copyright' do
    it { is_expected.to have_css('p', text: '© Spectre 2017') }
  end
end
