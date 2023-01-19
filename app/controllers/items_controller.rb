class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_message
rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

  def index
    user_id = (params[:user_id])
    items = user_id ? User.find(user_id).items : Item.all
    render json: items, include: :user
  end

  def show
    item = Item.find(params[:id])
    render json: item
  end

  def create
    user = User.find(params[:user_id])
    item = user.items.create!(item_params)
    render json: item, status: :created
  end

  private

  def render_not_found_message
    render json: {error: "User ID not found"}, status: :not_found
  end

  def item_params
    params.permit(:name, :description, :price)
  end

  def render_record_invalid(invalid)
    render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
  end

end
