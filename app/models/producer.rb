class Producer < ApplicationRecord
  validates :name, uniqueness: true, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 50 }

  scope :search_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :search_description, ->(description) { where('description ILIKE ?', "%#{description}%") }
end
