FactoryBot.define do
  factory :post do
    title { "MyString" }
    alias_name { "MyString" }
    content { "MyText" }
    is_published { false }
  end
end
