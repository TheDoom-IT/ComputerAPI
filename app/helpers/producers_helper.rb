module ProducersHelper
  PRODUCER_PAGE_SIZE = 50.0

  def pages(name, description)
    (find_producers(name, description).count / PRODUCER_PAGE_SIZE).ceil
  end

  def find_producers(name, description)
    Producer
      .search_name(name)
      .search_description(description)
      .order(:name)
  end
end
