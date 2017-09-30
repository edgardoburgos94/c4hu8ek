class Api::V1::PinsController < ApplicationController

  before_action :authenticate

  def index
    render json: Pin.all.order('created_at DESC')
  end

  def create
    pin = Pin.new(pin_params)
    if pin.save
      render json: pin, status: 201
    else
      render json: { errors: pin.errors }, status: 422
    end
  end

  private
  def pin_params
    params.require(:pin).permit(:title, :image_url)
  end

  def authenticate
    email = request.headers['X-User-Email']
    token = request.headers['X-Api-Token']
    puts "EMAIL: #{email}, TOKEN: #{token}"
    permision = User.exists?(api_token: request.headers['X-Api-Token'], email: request.headers['X-User-Email'])
    puts "IS IT VALID??? WELL WELL LETS SEE..... #{permision}"
    head :unauthorized unless permision
  end
end
