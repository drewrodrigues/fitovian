require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  test 'as guest, I can signup' do
    visit new_user_registration_path
    assert page.has_text?('Sign up', count: 2)

    assert_difference 'User.count', 1 do
      fill_in('Name', with: 'Andrew')
      fill_in('Email', with: 'example492@example.com')
      fill_in('Password', with: 'password')
      click_button('Sign up')
    end

    assert_equal billing_dashboard_path, current_path
    assert page.has_text?(
      'Welcome! You have signed up successfully.', count: 1
    )
  end

  test 'as guest, attempt signup' do
    visit new_user_registration_path
    assert page.has_content?('Sign up')

    assert_no_difference 'User.count' do
      click_button('Sign up')
    end

    # TODO: override devise routes /sign-up
    # assert_equal new_user_session_path, current_path
    # it starts as users/sign_up, upon fail it becomes /users
    # I want it to stay /sign_up the whole time
    assert page.has_text?('Email can\'t be blank', count: 1)
    assert page.has_text?('Password can\'t be blank', count: 1)
    assert page.has_text?('Name can\'t be blank', count: 1)
  end

  test 'as user, I can sign in' do
    user = User.new(
      name: 'Andrew', email: 'andrew@example.com', password: 'password'
    )
    assert user.save

    visit new_user_session_path
    assert page.has_text?('Sign in', count: 2)

    fill_in('Email', with: user.email)
    fill_in('Password', with: 'password')
    click_button('Sign in')

    assert_equal billing_dashboard_path, current_path
  end

  test 'as admin, I can sign in' do
    admin = User.new(
      name: 'Andrew', email: 'andrew@example.com',
      password: 'password', admin: true
    )
    assert admin.save

    visit new_user_session_path
    assert page.has_text?('Sign in', count: 2)

    fill_in('Email', with: admin.email)
    fill_in('Password', with: 'password')
    click_button('Sign in')

    assert_equal root_path, current_path
  end
end
