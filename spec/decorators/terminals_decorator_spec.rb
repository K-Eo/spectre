require 'rails_helper'

RSpec.describe TerminalsDecorator do
  describe 'new_link' do
    subject do
      TerminalsDecorator.new(Class.new).new_link
    end

    it { is_expected.to have_link('New Terminal', href: '/terminals/new') }
    it { is_expected.to have_css('a.btn.btn-success.float-right') }
  end

  describe 'pagination' do
    subject do
      allow(helpers).to receive(:paginate).and_return('foobar')
      terminals = build_stubbed_list(:terminal, 2)
      TerminalsDecorator.new(terminals).pagination
    end

    it { is_expected.to eq('foobar') }
  end
end
