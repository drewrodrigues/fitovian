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
  end

  scenario 'User signs out' do
    sign_in_user(create(:user))
    click_on 'Sign out'
    expect(page).to have_text('Signed out successfully.')
  end
end
