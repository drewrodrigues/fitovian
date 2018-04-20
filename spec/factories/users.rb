FactoryBot.define do
  factory :user do
    admin false
    sequence(:email) {|e| "drew#{e}@example.com"}
    name 'Drew'
    password 'password'
    stripe_id nil

    factory :admin do
      admin true
    end
  end
end
