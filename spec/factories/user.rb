FactoryBot.define do
  factory :user do
    email    { Faker::Internet.unique.email }
    password { Faker::Internet.password(8) }
    username { Faker::Internet.unique.user_name }
    uid      { Faker::Number.unique.number(10) }
  end

  trait :with_fb do
    password nil
    email nil
    provider 'facebook'
  end
end
