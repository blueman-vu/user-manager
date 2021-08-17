FactoryBot.define do
  factory :post do
    title { Faker::Name.name }
    content { "this is content" }
    is_published { false }
  end
end
