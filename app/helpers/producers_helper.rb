module ProducersHelper
  require 'application_helper'
  PRODUCER_PAGE_SIZE = 50.0

  def pages_producers(name, description)
    (find_producers(name, description).count / PRODUCER_PAGE_SIZE).ceil
  end

  def find_producers(name, description)
    producers = Producer.order(:name)
    producers = producers.search_name(name) unless nil_or_empty?(name)
    producers = producers.search_description(description) unless nil_or_empty?(description)
    producers
  end
end
