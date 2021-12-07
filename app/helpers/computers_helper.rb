module ComputersHelper
  COMPUTER_PAGE_SIZE = 50.0

  def pages_computers(name, producer_name, min_price, max_price)
    (find_computers(name, producer_name, min_price, max_price).count / COMPUTER_PAGE_SIZE).ceil
  end

  def find_computers(name, producer_name, min_price, max_price)
    computers = Computer.order(:name)
    computers = computers.search_name(name) unless nil_or_empty?(name)
    computers = computers.filter_min_price(min_price.to_i) unless min_price.to_i.zero?
    computers = computers.filter_max_price(max_price.to_i) unless max_price.to_i.zero?
    unless nil_or_empty?(producer_name)
      computers = computers.joins(:producer).merge(Producer.search_name(producer_name))
    end
    computers
  end
end
