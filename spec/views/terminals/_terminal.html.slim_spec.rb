require 'rails_helper'

describe 'terminals/_terminal' do
  let(:terminal) { build_stubbed(:terminal) }
  subject do
    render partial: 'terminals/terminal',
           locals: { terminal: terminal.decorate }
    rendered
  end

  it { is_expected.to have_css('li', id: "terminal_#{terminal.id}") }
  it { is_expected.to have_css('svg.octicon') }
  it { is_expected.to have_link(terminal.name, href: "/terminals/#{terminal.id}") }
  it { is_expected.to have_css('span.timeago') }
end
