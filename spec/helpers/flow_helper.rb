module FlowHelper
  def sign_in_user(user, button)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  def add_card
    within_frame 0 do
      '5555555555554444'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '5555'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '555'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '55555'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
  end

  def add_card2
    within_frame 0 do
      '4242424242424242'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '4242'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '424'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '24242'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
  end
end