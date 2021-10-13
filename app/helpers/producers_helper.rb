module ProducersHelper
  PRODUCER_PAGE_SIZE = 50.0

  def pages
    (Producer.count / PRODUCER_PAGE_SIZE).ceil
  end
end
