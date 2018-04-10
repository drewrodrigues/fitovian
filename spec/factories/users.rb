FactoryBot.define do
  factory :user do
    admin false
    email 'drew@example.com'
    name 'Drew'
    password 'password'
    stripe_id nil

    factory :admin do
      admin true
    end
  end
end
