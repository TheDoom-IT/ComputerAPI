module ComputersHelper
  COMPUTER_PAGE_SIZE = 50.0

  def pages_computers(name, producer_name, min_price, max_price)
    (find_computers(name, producer_name, min_price, max_price).count / COMPUTER_PAGE_SIZE).ceil
  end

  def find_computers(name, producer_name, min_price, max_price)
    computers = Computer.joins(:producer).order(:name)
    computers = computers.where('computers.name ILIKE ?', "%#{name}%") unless nil_or_empty?(name)
    computers = computers.where('producers.name ILIKE ?', "%#{producer_name}%") unless nil_or_empty?(producer_name)
    computers = computers.where('computers.price >= ?', min_price.to_i) unless min_price.to_i.zero?
    computers = computers.where('computers.price <= ?', max_price.to_i) unless max_price.to_i.zero?
    computers
  end
end
