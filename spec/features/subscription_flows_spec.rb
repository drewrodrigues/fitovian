require 'rails_helper'

RSpec.feature 'Subscription Flows', type: :feature do
  include FlowHelper

  before(:all) do
    StripeMock.start
    StripeMock.create_test_helper.create_plan(:id => 'starter', :amount => 1999)
    StripeMock.create_test_helper.create_plan(:id => 'premium', :amount => 3999)
  end

  after(:all) do
    StripeMock.stop
  end

  scenario 'New User subscribes to starter plan', js: true do
    user = create(:user)
    sign_in_user(user, 'Sign in')
    click_on 'Choose Starter'
    add_card
    click_on 'Subscribe'
    expect(page).to have_text('Successfully subscribed to starter plan', count: 1)
  end

  scenario 'New User subscribes to premium plan', js: true do
    user = create(:user)
    sign_in_user(user, 'Sign in')
    click_on 'Choose Premium'
    add_card
    click_on 'Subscribe'
    expect(page).to have_text('Successfully subscribed to premium plan', count: 1)
  end

  scenario 'New User cancels their subscription', js: true do
    user = create(:user)
    sign_in_user(user, 'Sign in')
    click_on 'Choose Premium'
    add_card
    click_on 'Subscribe'
    expect(page).to have_text('Successfully subscribed to premium plan', count: 1)
    visit billing_path
    click_on 'Cancel'
    expect(page).to have_text('Successfully canceled membership')
  end

  scenario 'New User cancels then immediately re-activates their subscription', js: true do
    user = create(:user)
    sign_in_user(user, 'Sign in')
    click_on 'Choose Premium'
    add_card
    click_on 'Subscribe'
    expect(page).to have_text('Successfully subscribed to premium plan', count: 1)
    visit billing_path
    click_on 'Cancel'
    expect(page).to have_text('Successfully canceled membership')
    click_on 'Re-activate'
  end
end