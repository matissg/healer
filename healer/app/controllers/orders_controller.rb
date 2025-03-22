class OrdersController < ApplicationController
  def new
    @order = Order.new
    @users = User.all
    @products = Catalog.fetch("products") || []
  end

  def create
    @order = Order.new(order_params)
    @order.product_name = product.name
    @order.price = product.price
    @order.total = @order.quantity.to_i * product.price.to_f

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

  def product
    @product ||= Catalog.fetch("products/#{order_params[:product_catalog_guid]}")&.first
  end

  def order_params
    params.require(:order).permit(:user_id, :product_catalog_guid, :quantity)
  end
end
