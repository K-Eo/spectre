require 'rails_helper'

describe 'terminals/_form' do
  context 'when create' do
    subject do
      assign(:terminal, Terminal.new)
      render
      rendered
    end

    it { is_expected.to have_css('form.new_terminal') }
    it { is_expected.to have_field('terminal_name', class: 'form-control') }
    it { is_expected.to have_css('input[type="submit"]', class: 'btn btn-primary') }
  end

  context 'when edit' do
    subject do
      assign(:terminal, build_stubbed(:terminal, name: 'foobar'))
      render
      rendered
    end

    it { is_expected.to have_css('form.edit_terminal') }
    it { is_expected.to have_field('terminal_name', class: 'form-control', with: 'foobar') }
    it { is_expected.to have_css('input[type="submit"]', class: 'btn btn-primary') }
  end
end
