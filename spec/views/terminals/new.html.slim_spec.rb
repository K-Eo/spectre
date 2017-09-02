require 'rails_helper'

describe 'terminals/new' do
  subject do
    assign(:terminal, Terminal.new)
    render
    rendered
  end

  it { is_expected.to have_css('form.new_terminal') }
end
