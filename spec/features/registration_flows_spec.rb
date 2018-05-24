require 'rails_helper'

RSpec.feature 'Registration Flows', type: :feature do
  scenario 'Guest signs up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'example@example.com'
    fill_in 'Password', with: 'password'
    click_button 'Sign up'

    expect(page).to have_text('You have signed up successfully.')
    expect(current_path).to eq(root_path)
  end

  scenario 'Guest tries to sign up with empty field' do
    visit new_user_registration_path
    click_button 'Sign up'

    expect(page).to have_text('Email can\'t be blank')
    expect(page).to have_text('Password can\'t be blank')
  end

  scenario 'Guest tries to sign up with a already used email' do
    user = create(:user)

    visit new_user_registration_path
    fill_in 'Email', with: user.email
    click_button 'Sign up'

    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_text('Email registered, try signing in!')
    expect(find_field('Email').value).to eq(user.email)
    expect(find_field('Password')[:autofocus]).to be_present
  end
end
