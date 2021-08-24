FactoryBot.define do
  factory :purchase do
    association :item
    association :user
  end
end
