class Producer < ApplicationRecord
  validates :name, uniqueness: true, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 50 }

  has_many :computers, dependent: :destroy

  scope :search_name, ->(name) { where('producers.name ILIKE ?', "%#{name}%") }
  scope :search_description, ->(description) { where('producers.description ILIKE ?', "%#{description}%") }
end
