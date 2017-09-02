require 'rails_helper'

describe 'terminals/edit' do
  subject do
    assign(:terminal, build_stubbed(:terminal, name: 'foobar'))
    render
    rendered
  end

  it { is_expected.to have_css('form.edit_terminal') }
end
