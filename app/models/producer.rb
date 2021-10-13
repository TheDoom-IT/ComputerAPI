class Producer < ApplicationRecord
  validates :name, uniqueness: true

  scope :search_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :search_description, ->(description) { where('description ILIKE ?', "%#{description}%") }

end
