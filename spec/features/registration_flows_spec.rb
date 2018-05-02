require 'rails_helper'

RSpec.feature 'Registration Flows', type: :feature do
  scenario 'Guest signs up' do
    visit new_user_registration_path
    fill_in 'Name', with: 'Drew'
    fill_in 'Email', with: 'example@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('You have signed up successfully.')
    expect(current_path).to eq(choose_plan_path)
  end

  scenario 'Guest tries to sign up with empty field' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_text('Name can\'t be blank')
    expect(page).to have_text('Email can\'t be blank')
    expect(page).to have_text('Password can\'t be blank')
  end

  scenario 'Guest tries to sign up with a already used email' do
    user = create(:user)

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    click_button 'Sign up'

    expect(page).to have_text('Email has already been taken')
  end
end
