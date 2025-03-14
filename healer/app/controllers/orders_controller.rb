class OrdersController < ApplicationController
  def new
    @order = Order.new
    @users = User.all
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path, notice: "Order was successfully created."
    else
      @users = User.all
      render :new
    end
  end

  def index
    @orders = Order.all
  end

  private

  def order_params
    params.require(:order).permit(:user_id, :total)
  end
end
