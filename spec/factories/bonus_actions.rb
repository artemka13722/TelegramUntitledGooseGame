FactoryBot.define do
  factory :bonus_action do
    success_message { 'MyString' }
    fun { 1 }
    mana { 1 }
    health { 1 }
    weariness { 1 }
    money { 1 }
  end
end
