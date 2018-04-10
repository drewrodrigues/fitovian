require 'rails_helper'

RSpec.feature 'Card Flows', type: :feature do
  include FlowHelper

  before(:all) do
    StripeMock.start
  end

  after(:all) do
    StripeMock.stop
  end

  # TODO: make helper methods to reduce code
  
  scenario 'New User adds a new card', js: true do
    user = create(:starter_plan).user
    sign_in_user(user, 'Sign in')

    expect(current_path).to eq(new_cards_path)
    within_frame 0 do
      '4242424242424242'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '4242'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '424'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '24242'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Subscribe'
    expect(page).to have_text('Successfully subscribed to starter plan')
    expect(current_path).to eq(lessons_path)
  end

  scenario 'User with a card adds another card', js: true do
    user = create(:starter_plan).user
    sign_in_user(user, 'Sign in')

    visit new_cards_path
    within_frame 0 do
      '5555555555554444'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '5555'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '555'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '55555'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Subscribe'
    expect(page).to have_text('Successfully subscribed to starter plan')
    expect(current_path).to eq(lessons_path)

    visit billing_path
    click_on 'Add new payment method'
    expect(current_path).to eq(new_cards_path)
    within_frame 0 do
      '4242424242424242'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '4242'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '424'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '24242'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Add'
    expect(page).to have_text('Successfully updated payment method')
    expect(current_path).to eq(billing_path)
    expect(user.cards.count).to eq(2)
  end

  scenario 'User sets a different card as default', js: true do
    user = create(:starter_plan).user
    sign_in_user(user, 'Sign in')

    visit new_cards_path
    within_frame 0 do
      '5555555555554444'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '5555'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '555'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '55555'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Subscribe'
    expect(page).to have_text('Successfully subscribed to starter plan')
    user.default_card.update_attribute(:last4, '4444') # stripe mock changes it
    expect(current_path).to eq(lessons_path)

    visit billing_path
    click_on 'Add new payment method'
    expect(current_path).to eq(new_cards_path)
    within_frame 0 do
      '4242424242424242'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '4242'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '424'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '24242'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Add'
    expect(page).to have_text('Successfully updated payment method')
    user.default_card.update_attribute(:last4, '4242') # stripe mock changes it
    expect(current_path).to eq(billing_path)

    visit billing_path
    click_on 'Set default'
    expect(user.default_card.last4).to eq('4444')
  end

  scenario 'User deletes a card', js: true do
    user = create(:starter_plan).user
    sign_in_user(user, 'Sign in')

    visit new_cards_path
    within_frame 0 do
      '5555555555554444'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '5555'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '555'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '55555'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Subscribe'
    expect(page).to have_text('Successfully subscribed to starter plan')
    user.default_card.update_attribute(:last4, '4444') # stripe mock changes it
    expect(current_path).to eq(lessons_path)
    expect(user.default_card.last4).to eq('4444')

    visit billing_path
    click_on 'Add new payment method'
    expect(current_path).to eq(new_cards_path)
    within_frame 0 do
      '4242424242424242'.split('').each { |c| find_field('Card number').native.send_keys(c) }
      '4242'.split('').each { |c| find_field('MM / YY').native.send_keys(c) }
      '424'.split('').each { |c| find_field('CVC').native.send_keys(c) }
      '24242'.split('').each { |c| find_field('ZIP').native.send_keys(c) }
    end
    click_button 'Add'
    expect(page).to have_text('Successfully updated payment method')
    user.default_card.update_attribute(:last4, '4242') # stripe mock changes it
    expect(current_path).to eq(billing_path)
    expect(user.default_card.last4).to eq('4242')
    expect(user.cards.count).to eq(2)

    visit billing_path
    click_on 'Delete'
    visit billing_path
    expect(user.default_card.last4).to eq('4242')
    expect(user.cards.count).to eq(1)
  end
end