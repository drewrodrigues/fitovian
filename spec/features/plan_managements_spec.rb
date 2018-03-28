require 'rails_helper'

RSpec.feature 'Plan Managements', type: :feature do
  scenario 'New User chooses a plan' do
    user = create(:user)
    visit new_user_session_path
    expect(user.plan).to be_nil

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(current_path).to eq(choose_plan_path)

    click_button 'Basic'
    expect(user.reload.plan.name).to eq('basic')
    expect(page).to have_text('Successfully chose basic plan')
  end

  scenario 'User chooses a plan when they already have a plan' do
    user = create(:user_with_plan)
    visit new_user_session_path
    expect(user.plan).to_not be_nil

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    visit choose_plan_path
    click_button 'Premium'
    expect(page).to have_text('Successfully chose premium plan')
    expect(user.reload.plan.name).to eq('premium')
  end
end
