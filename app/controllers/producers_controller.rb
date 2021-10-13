class ProducersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :producer_not_found
  skip_before_action :verify_authenticity_token

  # GET /producers or /producers.json
  def index
    page = index_params[:page] ? index_params[:page].to_i : 1
    offset = (page - 1) * ProducersHelper::PRODUCER_PAGE_SIZE
    producers = Producer
                  .limit(ProducersHelper::PRODUCER_PAGE_SIZE)
                  .offset(offset)
                  .search_name(index_params[:name])
                  .search_description(index_params[:description])
                  .order(:name)

    render json: {
      items: producers.length,
      page: page,
      pages: helpers.pages,
      data: producers
    }, status: 200
  end

  # GET /producers/1 or /producers/1.json
  def show
    producer = Producer.find(show_params[:id])
    render json: producer
  end

  # POST /producers or /producers.json
  def create
    producer = Producer.new(create_params)

    if producer.save
      render json: producer, status: 200
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

    producer.destroy
    render nothing: true, status: :ok
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_producer
    @producer = Producer.find(show_params[:id])
  end

  private

  def producer_not_found(exception)
    render json: { errors: ["Producer with the given id does not exist."] }, status: 404
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

end
