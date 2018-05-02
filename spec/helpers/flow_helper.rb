module FlowHelper
  # manually sign in user.
  # this should be performed while on the sign in page
  def sign_in_user(user, button=nil)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'
  end

  # manually enters test information for a Stripe::Card.
  # this should be performed when credit card information needs to be entered
  def add_card
    enter_card('5555555555554444', '5555', '555', '55555')
  end

  # the same as add_card, except different arguments
  def add_card2
    enter_card('4242424242424242', '4242', '424', '24242')
  end

  private

  def enter_card(num, mmyy, cvc, zip)
    within_frame 0 do
      num.split('').each { |c| find_field('Card number').native.send_keys(c) }
      mmyy.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      cvc.split('').each { |c| find_field('CVC').native.send_keys(c) }
      zip.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
  end
end