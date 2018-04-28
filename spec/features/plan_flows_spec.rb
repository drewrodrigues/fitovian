require 'rails_helper'

RSpec.feature 'Plan Flows', type: :feature do
  scenario 'New User chooses a plan' do
    user = create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    click_button 'Choose Starter'
    expect(page).to have_text('Successfully chose starter plan', count: 1)
  end
end
