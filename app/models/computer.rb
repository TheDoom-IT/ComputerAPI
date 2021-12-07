class Computer < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :producer_id, presence: true

  belongs_to :producer

  scope :search_name, ->(name) { where('computers.name ILIKE ?', "%#{name}%") }

  scope :filter_min_price, ->(min_price) { where('computers.price >= ?', min_price) }
  scope :filter_max_price, ->(max_price) { where('computers.price <= ?', max_price) }
end
