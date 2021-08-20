FactoryBot.define do
  factory :purchase_destination do
    postal_head = Faker::Number.number(digits: 3)
    postal_tail = Faker::Number.number(digits: 4)
    postal_number = "#{postal_head}-#{postal_tail}"
    postal_number { postal_number }
    prefecture_id { Faker::Number.between(from: 2, to: 48) }
    municipalities { Faker::Address.city }
    address { Faker::Address.street_address }
    building_name { Faker::Address.building_number }
    phone_number { Faker::Number.leading_zero_number(digits: 11) }
    token { 'tok_abcdefghijk00000000000000000' }
  end
end
