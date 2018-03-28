FactoryBot.define do
  factory :user do
    admin false
    email 'drew@example.com'
    name 'Drew'
    password 'password'

    factory :admin do
      admin true
    end

    factory :user_with_plan do
      after(:create) do |user|
        create_list(:plan, 1, user: user)
      end
    end

    factory :user_with_card do
      after(:create) do |user|
        create_list(:card_default, 1, user: user)
      end
    end

    factory :user_with_cards do
      after(:create) do |user|
        create_list(:card, 3, user: user)
        create_list(:card_default, 1, user: user)
      end
    end
  end
end
