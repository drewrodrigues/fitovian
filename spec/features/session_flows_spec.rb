require 'rails_helper'
require_relative '../helpers/flow_helper'

RSpec.feature 'Session Flows', type: :feature do
  include FlowHelper

  scenario 'User signs in' do
    user = create(:user)

    visit new_user_session_path
    fill_in 'Email',	with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    expect(page).to have_text('Signed in successfully.')
    expect(current_path).to eq(root_path)
  end

  scenario 'User signs out' do
    sign_in_user(create(:user), 's')

    click_on 'Sign out'

    expect(page).to have_text('Signed out successfully.')
  end

  scenario 'User attempts sign in with un-registered email' do
    user = build_stubbed(:user)

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    expect(current_path).to eq(new_user_registration_path)
    expect(page).to have_text('Email not registered, try signing up!')
    expect(find_field('Email').value).to eq user.email
    expect(find_field('Password')[:autofocus]).to be_present
  end
end
