class BonusAction < ApplicationRecord
  belongs_to :action
  has_many :bonus_conditions, dependent: :destroy
end
