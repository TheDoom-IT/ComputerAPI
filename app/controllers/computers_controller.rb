class ComputersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :computer_not_found
  before_action :authenticate, only: %i[create update destroy]

  # GET /computers or /computers.json
  def index
    param = [index_params[:name], index_params[:producer_name], index_params[:min_price], index_params[:max_price]]

    computers = helpers.find_computers(*param).limit(ComputersHelper::COMPUTER_PAGE_SIZE).offset(offset)

    pages = helpers.pages_computers(*param)
    render json: {
      items: computers.length,
      page: page,
      pages: pages,
      data: computers
    }, status: :ok
  end

  # GET /computers/1 or /computers/1.json
  def show
    computer = Computer.find(show_params[:id])
    render json: computer, status: :ok
  end

  # POST /computers or /computers.json
  def create
    Producer.transaction do
      producer = Producer.find_by(name: create_params[:producer_name])

      # add nonexistent producer
      producer = Producer.create(name: create_params[:producer_name]) if producer.nil?

      computer = Computer.new(name: create_params[:name], price: create_params[:price], producer_id: producer.id)

      if computer.save
        render json: computer, status: :ok
      else
        render json: { errors: computer.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue StandardError
    render json: { errors: ['Database error. Try again'] }, status: :internal_server_error
  end

  # PUT /computers/1 or /computers/1.json
  def update
    computer = Computer.find(update_params[:id])

    if computer.update(update_params)
      render json: computer, status: :ok
    else
      render json: { errors: computer.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /computers/1 or /computers/1.json
  def destroy
    computer = Computer.find(destroy_params[:id])

    computer.destroy
    head :ok
  end

  def computer_not_found
    render json: { errors: ['Computer with the given id does not exist.'] }, status: :not_found
  end

  def index_params
    params.permit(:name, :producer_name, :page, :min_price, :max_price)
  end

  def show_params
    params.permit(:id)
  end

  def create_params
    params.permit(:name, :price, :producer_name)
  end

  def update_params
    params.permit(:id, :name, :price)
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
    (page - 1) * ComputersHelper::COMPUTER_PAGE_SIZE
  end

  private

  def authenticate
    user = User.find_by(key: params[:key])

    render json: { errors: ['Invalid api key'] }, status: :unauthorized if user.nil?
  end
end
