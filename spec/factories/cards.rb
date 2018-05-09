FactoryBot.define do
  factory :card do
    stripe_id 'fake_stripe_id'
    default false
    last4 { rand(1000..9999) }
    user

    factory :card_default do
      default true
    end
  end
end
