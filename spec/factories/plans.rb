FactoryBot.define do
  factory :plan do
    name 'basic'
    price 1999
    stripe_id 'basic'
    user
  end
end