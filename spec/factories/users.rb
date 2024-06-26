FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    full_name { Faker::Name.name }
    password { Faker::Internet.password(max_length: 72, special_characters: true) }
    metadata { "#{Faker::Gender.type}, age #{SecureRandom.rand(70)}, #{Faker::Job.title}, #{Faker::Job.position}" }
  end
end
