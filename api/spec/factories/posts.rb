FactoryBot.define do
  factory :post do
    title { Faker::Name.name }
    content { "MyText" }
    is_published { false }
  end
end
