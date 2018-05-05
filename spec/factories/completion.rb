FactoryBot.define do
  factory :completion do
    user
    association :completable, factory: :lesson
  end
end
