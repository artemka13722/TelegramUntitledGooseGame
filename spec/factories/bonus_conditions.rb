FactoryBot.define do
  factory :bonus_condition do
    error_message { "MyString" }
    fun { false }
    mana { false }
    health { false }
    weariness { false }
    money { false }
    min { 1 }
    max { 1 }
  end
end
