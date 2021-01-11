class Action < ApplicationRecord
  has_many :action_conditions, dependent: :destroy
  has_many :bonus_actions, dependent: :destroy
end
