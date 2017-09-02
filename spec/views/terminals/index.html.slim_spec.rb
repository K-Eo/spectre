require 'rails_helper'

describe 'terminals/index' do
  def go(count = 1)
    terminals = build_stubbed_list(:terminal, count)
    page = Kaminari.paginate_array(terminals).page
    assign(:terminals, TerminalsDecorator.new(page))
    render
    rendered
  end

  context 'when terminals is =< 25' do
    subject { go(25) }

    it { is_expected.to have_link('New Terminal', href: '/terminals/new') }
    it { is_expected.to have_css('li[id^=terminal]', count: 25) }
    it { is_expected.to have_css('span.timeago', count: 25) }
    it { is_expected.not_to have_css('.pagination') }
  end

  context 'when terminals is > 25' do
    subject { go(26) }

    it { is_expected.to have_link('New Terminal', href: '/terminals/new') }
    it { is_expected.to have_css('li[id^=terminal]', count: 25) }
    it { is_expected.to have_css('span.timeago', count: 25) }
    it { is_expected.to have_css('.pagination') }
  end
end
