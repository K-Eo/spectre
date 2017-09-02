require 'rails_helper'

describe 'terminals/show' do
  context 'when is paired' do
    subject do
      terminal = build_stubbed(:terminal, paired: true)
      assign(:terminal, terminal)
      stub_template 'terminals/device/_details.html.slim' => '<div id="details">foobaz</div>'
      render template: 'terminals/show',
             locals: { terminal: terminal.decorate }
      rendered
    end

    it { is_expected.to have_css('h3') }
    it { is_expected.to have_css('p') }
    it { is_expected.to have_link('Edit') }
    it { is_expected.to have_link('Delete') }
    it { is_expected.to have_css('div#details', text: 'foobaz') }
  end

  context 'when is not paired' do
    subject do
      terminal = build_stubbed(:terminal, pairing_token: 'foobar')
      assign(:terminal, terminal)
      stub_template 'terminals/device/_pairing.html.slim' => '<div id="pairing">foobaz</div>'
      render template: 'terminals/show',
             locals: { terminal: terminal.decorate }
      rendered
    end

    it { is_expected.to have_css('h3') }
    it { is_expected.to have_css('p') }
    it { is_expected.to have_link('Edit') }
    it { is_expected.to have_link('Delete') }
    it { is_expected.to have_css('div#pairing', text: 'foobaz') }
  end
end
