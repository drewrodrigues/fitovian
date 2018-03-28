FactoryBot.define do  
  factory :card do
    user
    stripe_id 'something'
    default false
    last4 { rand(1000..9999) }

    factory :card_default do
      default true
    end
  end
end
