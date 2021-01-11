FactoryBot.define do
  factory :action_condition do
    error_message { 'MyString' }
    fun { false }
    mana { false }
    healt { false }
    weariness { false }
    money { false }
    min { 1 }
    max { 1 }
  end
end
