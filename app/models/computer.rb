class Computer < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :producer_id, presence: true

  belongs_to :producer
end
