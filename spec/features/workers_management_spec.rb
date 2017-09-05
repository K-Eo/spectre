require 'rails_helper'

RSpec.feature "WorkersManagement", type: :feature do
  let(:user) { create(:user, company_id: 1) }

  scenario "User adds a new worker" do
    visit new_user_session_path
    expect(page).to have_current_path(new_user_session_path)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'
    expect(page).to have_current_path(dashboard_path)
    visit workers_path
    fill_in 'worker_email', with: 'foo@bar.com'
    click_button 'Create Worker'
    expect(page).to have_current_path(workers_path)
    expect(page).to have_content(/Email sent to/)
    expect(last_email.to).to eq(['foo@bar.com'])
  end
end
