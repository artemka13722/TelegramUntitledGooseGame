FactoryBot.define do
  factory :goose do
    name { "MyString" }
    fun { 1 }
    mana { 1 }
    health { 1 }
    weariness { 1 }
    money { 1 }
    user { nil }
  end
end
