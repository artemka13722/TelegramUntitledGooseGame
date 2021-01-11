class User < ApplicationRecord
  has_many :goose, dependent: :destroy
end
