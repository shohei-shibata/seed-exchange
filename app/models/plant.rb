class Plant < ApplicationRecord
  belongs_to :user
  validates :name, length: { maximum: 30 }, presence: true
end
