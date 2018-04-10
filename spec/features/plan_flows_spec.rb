require 'rails_helper'

RSpec.feature 'Plan Flows', type: :feature do
  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

  scenario 'New User chooses a plan' do
    user = create(:user)
    visit new_user_session_path
    expect(user.plan).to be_nil

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
    expect(current_path).to eq(choose_plan_path)

    click_button 'Choose Starter'
    expect(user.reload.plan.name).to eq('starter')
    expect(page).to have_text('Successfully chose starter plan', count: 1)
  end

  scenario 'User chooses a plan when they already have a plan' do
    user = create(:user)
    visit new_user_session_path
    expect(user.plan).to be_nil

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    visit choose_plan_path
    click_button 'Starter'
    expect(page).to have_text('Successfully chose starter plan', count: 1)
    expect(user.reload.plan.name).to eq('starter')

    visit choose_plan_path
    click_button 'Choose Premium'
    expect(page).to have_text('Successfully chose premium plan', count: 1)
    expect(user.reload.plan.name).to eq('premium')
  end
end
