FactoryBot.define do
  factory :user do
    name { "Name" }
    email { "example@example.com" }
    password { "password" }
    password_confirmation { "password" }
    key { "mykey" }
  end
end
