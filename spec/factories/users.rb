FactoryBot.define do
  factory :user do
    transient do
      person { Gimei.name }
    end
    nickname { Faker::Internet.username }
    email { Faker::Internet.free_email }
    password = '1a' + Faker::Internet.password(min_length: 6)
    password { password }
    password_confirmation { password }
    first_name { person.first.kanji }
    last_name { person.last.kanji }
    first_name_reading { person.first.katakana }
    last_name_reading { person.last.katakana }
    birth_day { Faker::Date.between(from: '1930-01-01', to: '2016-12-31') }
  end
end
