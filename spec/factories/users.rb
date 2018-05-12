require_relative '../helpers/cards_helper.rb'
include CardsHelper

FactoryBot.define do
  factory :user do
    admin false
    sequence(:email) { |e| "drew#{e}@example.com" }
    name 'Drew'
    password 'password'
    stripe_id nil
    plan 'starter'
    period_end 3.days.from_now

    trait :with_card do
      after(:create) do |u|
        add_fake_card(u, false)
      end
    end

    trait :with_default_card do
      after(:create) do |u|
        add_fake_card(u, true)
      end
    end

    trait :with_cards do
      after(:create) do |u|
        add_fake_card(u)
        add_fake_card(u)
        add_fake_card(u)
      end
    end

    trait :with_cards_one_default do
      after(:create) do |u|
        add_fake_card(u)
        add_fake_card(u)
        add_fake_card(u, true)
      end
    end

    factory :admin do
      admin true
    end
  end
end
