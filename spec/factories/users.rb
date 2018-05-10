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

    trait :with_card do
      after(:create) do |u|
        add_fake_card(u)
      end
    end

    factory :admin do
      admin true
    end
  end
end
