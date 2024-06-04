FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    phone_number { Faker::PhoneNumber.phone_number }
    full_name { Faker::Name.name }
    password { Faker::Internet.password(max_length: 60, special_characters: true) }
    key { SecureRandom.alphanumeric(100) }
    account_key { SecureRandom.alphanumeric(100) }
    metadata { "#{Faker::Gender.type}, age #{SecureRandom.rand(70)}, #{Faker::Job.title}, #{Faker::Job.position}" }
  end
end
