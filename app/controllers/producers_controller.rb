class ProducersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :producer_not_found
  skip_before_action :verify_authenticity_token

  # GET /producers or /producers.json
  def index
    producers = helpers.find_producers(index_params[:name], index_params[:description])
                       .limit(ProducersHelper::PRODUCER_PAGE_SIZE)
                       .offset(offset)
    pages = helpers.pages_producers(index_params[:name], index_params[:description])

    render json: {
      items: producers.length,
      page: page,
      pages: pages,
      data: producers
    }, status: :ok
  end

  # GET /producers/1 or /producers/1.json
  def show
    producer = Producer.find(show_params[:id])
    render json: producer, status: :ok
  end

  # POST /producers or /producers.json
  def create
    producer = Producer.new(create_params)

    if producer.save
      render json: producer, status: :ok
    else
      render json: { errors: producer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT /producers or /producers.json
  def update
    producer = Producer.find(update_params[:id])

    if producer.update(update_params)
      render json: producer, status: :ok
    else
      render json: { errors: producer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /producers/1 or /producers/1.json
  def destroy
    producer = Producer.find(destroy_params[:id])

    if Computer.where(producer_id: producer.id).count.zero?
      producer.destroy
      head :ok
    else
      render json: { errors: ['Producer is used by some computer. Delete computers first.'] }, status: :bad_request
    end
  end

  def producer_not_found(exception)
    render json: { errors: ["Producer with the given id does not exist."] }, status: :not_found
  end

  # Only allow a list of trusted parameters through.
  def index_params
    # GET /producers
    params.permit(:name, :description, :page)
  end

  def show_params
    params.permit(:id)
  end

  def create_params
    params.permit(:name, :description)
  end

  def update_params
    params.permit(:id, :name, :description)
  end

  def destroy_params
    params.permit(:id)
  end

  def page
    page = index_params[:page].to_i.abs
    if page.zero?
      1
    else
      page
    end
  end

  def offset
    (page - 1) * ProducersHelper::PRODUCER_PAGE_SIZE
  end
end
