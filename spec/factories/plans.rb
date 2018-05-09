FactoryBot.define do
  factory :plan do
    user

    factory :starter_plan do
      name { Plan::STARTER[:name] }
      price { Plan::STARTER[:price] }
      stripe_id { Plan::STARTER[:stripe_id] }
    end
  end
end
