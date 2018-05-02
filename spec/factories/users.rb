require_relative '../helpers/cards_helper.rb'
include CardsHelper

FactoryBot.define do
  factory :user do
    admin false
    sequence(:email) {|e| "drew#{e}@example.com"}
    name 'Drew'
    password 'password'
    stripe_id nil

    trait :with_plan do
      after(:create) { |u| u.select_starter_plan }
    end

    trait :with_plan_and_card do
      after(:create) do |u|
        u.select_starter_plan
        add_fake_card(u)
      end
    end

    trait :onboarded do
      after(:create) do |u|
        u.select_starter_plan
        add_fake_card(u)
        u.subscribe
      end
    end

    factory :admin do
      admin true
    end
  end
end
